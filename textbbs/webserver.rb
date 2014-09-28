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
        req.query['request_time'] = req.request_time.strftime('%Y/%m/%d %H:%M:%S')
        db = PStore.new('pstore', true)
        db.transaction{ |pstore|
            ary = pstore.roots
            if ary.empty?
				#キーは、1から始まる
                pstore[1] = req.query
            else
                pstore[ary.length + 1] = req.query
            end
        }
        template = ERB.new(File.read('erb/write.erb'))
        res.body << template.result(binding)    
    rescue ArgumentError => ae
        template = ERB.new(File.read('erb/error.erb'))
        res.body << template.result(binding)
    end
}

server.mount_proc("/next") { |req, res|
    template = ERB.new(File.read('erb/nextpage.erb'))
    res.body << template.result(binding)
}

server.mount_proc("/previous") { |req, res|
    template = ERB.new(File.read('erb/previouspage.erb'))
    res.body << template.result(binding)
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
