class MainController < Controller

  def index
    puts "INDEX ACTION:"
    @cookies = @request.cookies
    @name=params['name']
    @params = params
    @method = @request.request_method
  end

  def cookie
    puts "COOKIE ACTION:"
    set_cookie params['key'], params['value']
    redirect_to '/'
  end

  def clearcookie
    @request.cookies.each_key do |key|
      @response.delete_cookie(key)
    end
    redirect_to '/'
  end
end