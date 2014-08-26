require 'webrick'

server_config = {
    :Port => 8099,
    :DocumentRoot => '.',
    :MiMeTypes["erb"] => "text/html"
}

#WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)
server = WEBrick::HTTPServer.new(server_config)

server.mount_proc("/write") { |req, res|
    template = ERB.new(File.read('erb/write.erb'))
    res.body << template.result(binding)
}

trap(:INT) {
    server.shutdown
}

server.start