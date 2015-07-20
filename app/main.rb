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
  #Si response no devuelve el objeto del usuario de redmine volvemos a la página de login
  
  if !response.nil?
    #guardamos los datos de user/pass y objeto de usuario de redmine en la sesión de sinatra
    session[:loginname] = params[:name]
    session[:loginpass] = params[:password]
    session[:user] = response['user']
    redirect '/user'
  else 
    redirect '/login'
  end
  ##binding.pry

  
end

get '/user' do
  #validamos si el usuario se ha autentificado correctamente.
  if session.nil?
    redirect '/login'
  end
  
  response = RedmineUser.new.getprojects(session[:user]['api_key'])
  
  if !response.nil?
    @projects = response
  else
    redirect '/login'
  end
  
  erb  :user

end 

get '/project/:id' do
    #binding.pry
  #validamos si el usuario se ha autentificado correctamente.
  if session.nil?
    redirect '/login'
  end

  path = @config['config']['url'] + 'issues.json?project_id=' + params[:id] + '&key=' + session[:user]['api_key']
  response = RedmineIssues.new.getissues path
  
  if !response.nil?
    @issues = response['issues']
  end
  
  pathmembers = @config['config']['url'] + 'projects/' + params[:id] + '/memberships.json'
  responsemembers = RedmineIssues.new.getprojectusers pathmembers,session
  
  if !responsemembers .nil?
    @members = responsemembers
  end
  
  erb :issues
  #"Hello '#{responsemembers}' <br>  <br>  "

  
end
