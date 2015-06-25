class RedmineIssues

  def getissues (path)

    uri = URI.parse(path)
    req = Net::HTTP::Get.new(uri)
    response = nil
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|	  response = http.request(req)	}
    binding.pry
    return response  

  end

end
