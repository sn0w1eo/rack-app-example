require_relative 'app/web-app'

#Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each {|file| require file }
#Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each {|file| require file }

use Rack::Reloader, 0

use Rack::Static,
	:urls => ["/css", "/images", "/js"],
	:root => 'public'

run WebApp
