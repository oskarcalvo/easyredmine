class RedmineIssues

  def getissues (path)

    uri = URI.parse(path)
    req = Net::HTTP::Get.new(uri)
    response = nil
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|	  response = http.request(req)	}
    #binding.pry
    
    
    case response
    when  Net::HTTPSuccess then
      data = JSON.parse(response.body)
      return data
    else
      return nil
    end   
      

  end
  
  def getprojectusers(path, session)

    uri = URI.parse(path)
    req = Net::HTTP::Get.new(uri)
    response = nil
    req.basic_auth session[:loginname], session[:loginpass]
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|	  response = http.request(req)	}
    #binding.pry
    
    
    case response
    when  Net::HTTPSuccess then
      data = JSON.parse(response.body)
      return data
    else
      return nil 
    end   
  
  end


  def getissuepriorities(path, session)

    uri = URI.parse(path)
    req = Net::HTTP::Get.new(uri)
    response = nil
    req.basic_auth session[:loginname], session[:loginpass]
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|   response = http.request(req)  }
    #binding.pry
    
    
    case response
    when  Net::HTTPSuccess then
      data = JSON.parse(response.body)
      return data
    else
      return nil 
    end   

  end

  def getissuedata(path, session)

    uri = URI.parse(path)
    req = Net::HTTP::Get.new(uri)
    response = nil
    req.basic_auth session[:loginname], session[:loginpass]
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|   response = http.request(req)  }
    #binding.pry
    
    
    case response
    when  Net::HTTPSuccess then
      data = JSON.parse(response.body)
      return data
    else
      return nil 
    end   

  end


end
