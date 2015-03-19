# coding: utf-8
require 'csv'
require 'pp'

class Content
  attr_accessor :path, :size
  
  def initialize(path, size=0)
    @path = path
    @size = size
  end
end

if ARGV[0].nil?
  current_dir = File.expand_path(File.dirname(__FILE__))
else
  current_dir = ARGV[0]
end
dirs = Dir.glob("#{current_dir}/*")

def current_content(hash, parent_dir, dirs)
  arr = []
  dirs.each do |content|
    c = Content.new(content, content.size)
    if FileTest.file?(content)
      c = Content.new(content, content.size)
      arr << c
    else
      c = Content.new(content)
      arr << c
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
=begin
CSV.open('test.csv', "w") do |writer|
  writer << ['parent_dir','full_path', 'size']
  hash.each do |parent,contents|
  puts contents.class
	contents.each do |cc|
	  puts cc.path
	  puts cc.size
	end
  end
end
=end