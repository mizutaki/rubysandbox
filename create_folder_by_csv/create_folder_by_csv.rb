require 'csv'
require 'fileutils'

file_name = ARGV[0]

p file_name
raise IOError.new("ファイル#{file_name}が存在しません。") unless File.exist?(file_name)
raise IOError.new("拡張子がcsvではありません。") unless File.extname(file_name).eql?(".csv")

csv = CSV.read(file_name)

puts "以下の名前のフォルダをカレントディレクトリに作成します。"
puts csv.inspect
puts "よろしいですか？y or n"

loop {
  answer = STDIN.gets.chomp.downcase
  if answer.eql?("y")
    puts "y"
    break
  elsif answer.eql?("n")
    puts "n"
    exit 0
  else 
    puts "yかnを入力してください。"
    next
  end
}

csv.flatten.each do |folder_name|
  p folder_name
  FileUtils.mkdir(folder_name) unless FileTest.exist?(folder_name)
end
