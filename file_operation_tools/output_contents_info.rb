# coding: utf-8
require 'csv'
require 'pp'

if ARGV[0].nil?
  current_dir = File.expand_path(File.dirname(__FILE__))
else
  current_dir = ARGV[0]
end
dirs = Dir.glob("#{current_dir}/*")

def current_content(hash, parent_dir, dirs)
  arr = []
  dirs.each do |content|
    if FileTest.file?(content)
      arr << content
    else
      arr << content
      hash[parent_dir] = arr
      parent_dir = File.basename(content)
      current_content(hash, parent_dir, Dir.glob("#{content}/*")) 
    end
  end
end

parent_dir = File.basename(current_dir)
hash = {}
current_content(hash, parent_dir, dirs)
pp hash