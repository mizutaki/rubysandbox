# coding: utf-8
current_dir = File.expand_path(File.dirname(__FILE__))
dirs = Dir.glob("#{current_dir}/*")

def current_content(dirs)
  dirs.each do |content|
  
    if FileTest.file?(content)
      puts "FILE" 
      puts content
      puts "#{File.size(content)}byte"
    else
      puts "DIR"
      puts content
    end
  end
end

current_content(dirs)