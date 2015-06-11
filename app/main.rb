require 'sinatra'
require 'net/http'
require 'uri'
require 'yaml'

# Listen on all interfaces in the development environment
set :bind, '0.0.0.0'

get '/' do
  "Just Do It"
end

get '/login' do
  erb :loginform
  
end

post '/loginvalidate' do
	config = YAML.load_file("conf/config.yaml")
	uri = URI.parse(config["config"]["url"], config["config"]["domain"])
	req = Net::HTTP::Get.new(uri)
	request = nil
	req.basic_auth config["config"]["user"], config["config"]["pass"]
	res = Net::HTTP.start(uri.hostname, uri.port) {|http|
	  request = http.request(req)
	}

	"You said '#{params[:name]}' and '#{params[:password]}'"
  
end
