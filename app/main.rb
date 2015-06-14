require 'sinatra'
require 'net/http'
require 'uri'
require 'yaml'
require 'pry'
require 'json'

# Listen on all interfaces in the development environment
set :bind, '0.0.0.0'
enable :sessions

get '/' do
  "Just Do It"
end

get '/login' do
  erb :loginform
  
end

post '/loginvalidate' do
	config = YAML.load_file("conf/config.yaml")
  path = config["config"]["url"] + config["config"]["userobject"]
	
  uri = URI.parse(path)
	req = Net::HTTP::Get.new(uri)
	response = nil
	req.basic_auth config["config"]["user"], config["config"]["pass"]
	res = Net::HTTP.start(uri.hostname, uri.port) {|http|	  response = http.request(req)	}
  binding.pry
  
  
  case response
  when  Net::HTTPSuccess then
    data = JSON.parse(response.body)
    session['user'] = data['user']
  else
    redirect '/login'
  end  
  
  binding.pry
  #@path = path
  #erb :loginvalidate
	"You said '#{params[:name]}' and '#{params[:password]}' <br> '#{data['user']['api_key']}'"
  
end

get '/user/:id'
  


end 
