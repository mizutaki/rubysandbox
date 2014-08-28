require 'webrick'
require 'pry'
server_config = {
    :Port => 8099,
    :DocumentRoot => '.',
    :MiMeTypes["erb"] => "text/html"
}

#WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)
server = WEBrick::HTTPServer.new(server_config)

server.mount_proc("/write") { |req, res|
    #binding.pry
    begin
        validate_parameter req.query
        template = ERB.new(File.read('erb/write.erb'))
        res.body << template.result(binding)    
    rescue ArgumentError => ae
        template = ERB.new(File.read('erb/error.erb'))
        res.body << template.result(binding)
    end
}

trap(:INT) {
    server.shutdown
}

def validate_parameter(query)
    if query['name'].empty?
        raise ArgumentError.new("名前を入力して下さい。") 
    end
    p query
    if query['textarea'].empty?
        raise ArgumentError.new("本文を入力して下さい。")
    end
end

server.start