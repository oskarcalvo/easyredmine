require 'sinatra'
require 'net/http'
require 'uri'
require 'yaml'
require 'pry'
require 'json'

# Listen on all interfaces in the development environment

configure do 
set :bind, '0.0.0.0'
enable :sessions

end

before do
	@config = YAML.load_file("conf/config.yaml")
end


get '/' do
  "Just Do It"
end

get '/login' do
  erb :loginform
  
end

post '/loginvalidate' do

  path = @config["config"]["url"] + @config["config"]["userobject"]
	
  uri = URI.parse(path)
	req = Net::HTTP::Get.new(uri)
	response = nil
	req.basic_auth @config["config"]["user"], @config["config"]["pass"]
	res = Net::HTTP.start(uri.hostname, uri.port) {|http|	  response = http.request(req)	}
  binding.pry
  
  
  case response
  when  Net::HTTPSuccess then
    data = JSON.parse(response.body)
    session[:user] = data['user']
    redirect '/user'
  else
    redirect '/login'
  end  
  
  binding.pry
  #@path = path
  #erb :loginvalidate
	"You said '#{params[:name]}' and '#{params[:password]}' <br> '#{session[:user]}'"
  
end

get '/user' do

  #comprobar que el id de sessión es el mismo del id de la url
  
  path = @config["config"]["url"] + @config["config"]["userprojects"]
	
  uri = URI.parse(path)
	req = Net::HTTP::Get.new(uri)
	response = nil
	req.basic_auth @config["config"]["user"], @config["config"]["pass"]
	res = Net::HTTP.start(uri.hostname, uri.port) {|http|	  response = http.request(req)	}
  binding.pry
  
  projects = nil
  
  case response
  when  Net::HTTPSuccess then
    data = JSON.parse(response.body)
    projects = data['user']['memberships']
  else
    session.clear
    redirect '/'
  end   
  
  @projects = projects
  erb  :user
  
  #listofprojects = {}
  #projects.each do |project|
  #  listofprojects [project['project']['id'], project['project']['name']] 
  #end
  #"Hello user <pre>'#{listofprojects}' </pre> "
  
  

end 
