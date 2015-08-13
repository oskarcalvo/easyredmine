#require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'
require 'yaml'
require 'pry'
require 'json'
require 'sinatra/assetpack'


require_relative 'vendor/redmine_user.rb'
require_relative 'vendor/redmine_issues.rb'
#require_relative 'helpers/redminehtmlhelper.rb'
#http://recipes.sinatrarb.com/p/asset_management/sinatra_assetpack
#http://blog.sourcing.io/structuring-sinatra

# Listen on all interfaces in the development environment


module Sinatra
  module HtmlHelpers

    # Basic implementation of a HTML SELECT helper
    def select(name, options_list, selected_value)
      html = ''
      options_list.each do |nv_pair|
        option_value = nv_pair[0]
        option_name = nv_pair[1]
        html << "<option value=\"#{option_value}\""
        html << " selected=\"true\"" if option_value == selected_value
        html << '>'
        html << option_name
        html << "</option>"
      end
      "<select class=\"#{name}\"  name=\"#{name}\">#{html}</select>"
    end


    def cleanhash(hash)

      newhash = Hash.new
      hash.each do |nv_pair|
        option_name = nv_pair['name']
        option_value = nv_pair['id']
        newhash[option_value] = option_name

      end
      newhash
    end

  end

  helpers HtmlHelpers
end




configure do 
set :bind, '0.0.0.0'
enable :sessions
set :static_cache_control, [:public, max_age: 60 * 60 * 24 * 365]
  register Sinatra::AssetPack
  assets do
    serve '/js', :from => 'asset/js'
    js :application, [
      '/js/jquery.js',
      '/js/foundation.min.js',
      '/js/easyredmine.js',
      '/js/vendor/*.js'
    ]
    
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
  if !responsemembers.nil?
    @members = responsemembers['memberships'].inject({}) {|sum, elem| sum[elem['user']['id']] = elem['user']['name']; sum}
  end

  pathpriorities = @config['config']['url'] + 'enumerations/issue_priorities.json'
  responsepriorities = RedmineIssues.new.getissuepriorities pathpriorities, session

  if !responsepriorities.nil?
    @priorities = responsepriorities['issue_priorities'].inject {|sum, elem| sum[elem['id']] = elem['name']; sum}
  
  end

  pathtracker = @config['config']['url']  + 'projects/' + params[:id] + '.json?include=trackers'
  responsetrackers = RedmineIssues.new.getissuedata pathtracker, session

  if !responsetrackers.nil?
    @trackers = cleanhash ( responsetrackers['project']['trackers'])
  #   @trackers = responsetrackers['project']['trackers'].inject {|sum, elem| sum[elem['id']] = elem['name']; sum}
  end

  #Pasamos la variable con la url de redmine.
  @path = @config['config']['url']

  erb :issues
  #"Hello '#{@trackers}' "

  
end
