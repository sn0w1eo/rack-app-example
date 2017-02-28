require 'erb'
require 'json'
require 'pry'
require_relative 'controller'

ROUTES = {
		'/' => 'main#index',
		'/index' => 'main#index',
		'/cookie' => 'main#cookie',
		'/clear' => 'main#clearcookie'
}


class WebApp
	def self.call(env)
		new(env).response.finish
	end

	def initialize(env)
		@request = Rack::Request.new(env)
	end


	def response
		if ROUTES.has_key?(@request.path)
			Controller.new_controller_and_action( @request ).call
		else
			Rack::Response.new("URL: #{@request.path} not found")
		end
	end
end



=begin

	def response
		case @request.path
		when "/"
			Rack::Response.new(render("index"))
		when "/change"
			Rack::Response.new do |response|
				response.set_cookie("greet", @request.params["name"])
				response.redirect('/')
			end
		when "/block"
			Rack::Response.new(@request.params.to_s)
		else
			Rack::Response.new("#{@request.path}: Not Created", 404)
		end
	end

	def render(template)
		path = File.expand_path("../views/#{template}.html.erb", __FILE__)
		ERB.new(File.read(path)).result(binding)
	end

=end