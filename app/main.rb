require 'sinatra'
require 'net/http'
require 'uri'
require 'yaml'
require 'pry'
require 'json'
require 'sinatra/assetpack'

require_relative 'vendor/redmine_user.rb'
require_relative 'vendor/redmine_issues.rb'
#http://recipes.sinatrarb.com/p/asset_management/sinatra_assetpack
#http://blog.sourcing.io/structuring-sinatra

# Listen on all interfaces in the development environment

configure do 
set :bind, '0.0.0.0'
enable :sessions

  register Sinatra::AssetPack
  assets do
    serve '/js', :from => 'asset/js'
    js :application, ['/js/*.js']
    
    serve '/css', :from => 'asset/css'
    css :application, ['/css/*.css']
    
  end


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
 
  response = RedmineUser.new.getuser(params[:name],params[:password])
  
  case response
  when  Net::HTTPSuccess then
    data = JSON.parse(response.body)
    session[:user] = data['user']
    redirect '/user'
  else
    redirect '/login'
  end    
  binding.pry

  
end

get '/user' do

  response = RedmineUser.new.getprojects(session[:user]['api_key'])
  
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

end 

get '/project/:id' do

  path = @config['config']['url'] + 'issues.json?project_id=' + params[:id] + '&key=' + session[:user]['api_key']

  response = RedmineIssues.new.getissues (path)
  #@issues = response['issues']
  #erb :issues
  "Hello '#{response}'"

  
end
