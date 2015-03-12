# coding: utf-8
require 'csv'

current_dir = File.expand_path(File.dirname(__FILE__))
dirs = Dir.glob("#{current_dir}/*")

def current_content(dirs)
  dirs.each do |content|
    CSV.open('test.csv', 'w+') do |writer|
      if FileTest.file?(content)
        puts "FILE" 
        puts content
        puts "#{File.size(content)}byte"
        writer << ["#{content}", "#{File.size(content)}"]
      else
        puts "DIR"
        puts content
        writer << ["#{content}", "0"]
        current_content(Dir.glob("#{content}/*")) 
      end
    end
  end
end

current_content(dirs)