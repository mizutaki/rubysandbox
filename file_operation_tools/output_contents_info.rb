# coding: utf-8
require 'csv'

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

def current_content(hash, parent_content, dirs)
  arr = []
  parent_dir = nil
  dirs.each do |content|
    c = Content.new(content, content.size)
    if FileTest.file?(content)
      c = Content.new(content, content.size)
      arr << c
    else
      c = Content.new(content)
      arr << c
      current_content(hash, content, Dir.glob("#{content}/*"))
    end
  end
  parent_dir = File.basename(parent_content)
  #parent_dir = File.basename(parent_content) if parent_dir.nil?
  hash[parent_dir] = arr
end

hash = {}
current_content(hash, current_dir, dirs)
CSV.open('test.csv', "w") do |writer|
  writer << ['parent_dir','full_path', 'size']
  hash.each do |parent,contents|
    contents.each do |content|
    writer << [parent, content.path, content.size]
    end
  end
end
