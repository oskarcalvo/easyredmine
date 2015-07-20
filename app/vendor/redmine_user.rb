class RedmineUser
  USEROBJECT = 'users/current.json'
  USERPROJECTS = 'users/current.json?include=memberships'
  
  def initialize()
    @config = YAML.load_file("./conf/config.yaml")
  
  end
  
  def getuser (user, pass)
    path = @config["config"]["url"] + USEROBJECT
	
    uri = URI.parse(path)
    req = Net::HTTP::Get.new(uri)
    response = nil
    req.basic_auth user, pass
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|	  response = http.request(req)	}
    #binding.pry
    
    data = nil
    
    case response
      when  Net::HTTPSuccess then
        data = JSON.parse(response.body)
        return data
      else
      return nil
    end    
    
  end

  def getprojects (apikey)
    path = @config['config']['url'] + USERPROJECTS + '&key=' + apikey
    
    uri = URI.parse(path)
    req = Net::HTTP::Get.new(uri)
    response = nil
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|	  response = http.request(req)	}
    #binding.pry
    
    projects = nil
  
    case response
    when  Net::HTTPSuccess then
      data = JSON.parse(response.body)
      projects = data['user']['memberships']
      return projects
    else
      return nil
    end  
    
    
    
  end

end
