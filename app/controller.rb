class Controller

  attr_reader :controller, :action, :request
  attr_accessor :response

  def initialize( controller, action, request )
    @controller = controller
    @action = action
    @request = request
    @response = Rack::Response.new('OK')
    @response.status = 200
    @response.set_header('Content-Type', 'text/html')
  end

  def call
      begin
        send @action
        return @response if @response.get_header('Location')
        @response.status = 200
        set_body( get_template )
        @response
      rescue
        internal_error
      end
  end

	def params
    @request.params
  end

  def self.new_controller_and_action( request )
    controller, action = ROUTES[request.path].split('#')
    controller_obj_name = "#{controller.capitalize}Controller" if controller
    action &&= action.downcase
    Object.const_get(controller_obj_name).new(controller, action, request)
  end

  def get_template
    view = File.read(File.expand_path("views/#{@controller}/#{@action}.html.erb", __dir__))
    ERB.new(view).result(binding)
  end

  def redirect_to( url )
    @response.status = 302
    @response.set_header( 'Location', url )
  end

  def set_cookie(key,value)
    @response.set_header('Set-Cookie' , "#{key.to_s}=#{value.to_s}")
  end

  def internal_error # 5
    @response.status = 404
    @response.set_header( 'Content-Type' , 'text/plain' )
    @response.body.clear
    @response.write(["Internal error"])
    @response
  end

  def set_body( body )
    @response.body.clear
    @response.length = 0
    @response.set_header( 'Content-Length', @response.body.join.length.to_s )
    @response.write( body )
  end
end

Dir[File.join(File.dirname(__FILE__), 'controllers', '*.rb')].each {|file| require file }
