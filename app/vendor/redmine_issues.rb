class RedmineIssues

  def getissues (path)

    uri = URI.parse(path)
    req = Net::HTTP::Get.new(uri)
    response = nil
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|	  response = http.request(req)	}
    binding.pry
    
    
    case response
    when  Net::HTTPSuccess then
      data = JSON.parse(response.body)
      return data
    else
      redirect '/'
    end   
      

  end

end
