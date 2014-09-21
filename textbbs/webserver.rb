require 'webrick'
require 'pstore'
require 'pry'

server_config = {
    :Port => 8099,
    :DocumentRoot => '.',
    :MiMeTypes["erb"] => "text/html"
}

#WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)
server = WEBrick::HTTPServer.new(server_config)

server.mount_proc("/write") { |req, res|
    begin
        validate_parameter req.query
        request_time = req.request_time.strftime('%Y/%m/%d %H:%M:%S')
        db = PStore.new('pstore', true)
        db.transaction{ |psotre|
            psotre[request_time]= req.query
        }

        template = ERB.new(File.read('erb/write.erb'))
        res.body << template.result(binding)    
    rescue ArgumentError => ae
        template = ERB.new(File.read('erb/error.erb'))
        res.body << template.result(binding)
    end
}

server.mount_proc("/reply") {|req, res|
	p 'reply skeleton'
}

trap(:INT) {
    server.shutdown
}

def validate_parameter(query)
    if query['name'].empty?
        raise ArgumentError.new("名前を入力して下さい。") 
    end
    if query['textarea'].empty?
        raise ArgumentError.new("本文を入力して下さい。")
    end
	if query['title'].empty?
		query['title'] = '無題'
	end
	#TODO judge a address
end

server.start
