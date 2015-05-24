require 'open-uri'
require 'nokogiri'
require 'csv' 
require 'yaml'
require 'parallel'
#サンプルデータ追記用のスクリプト
#wikipedia(英語版、日本語版)にランダムにアクセスして単語を取得して、csvファイルに追記する

wiki_url = ["http://wikipedia.org/wiki/Special:Randompage", "http://ja.wikipedia.org/wiki/Special:Randompage"]

conf = YAML.load_file('conf.yml')
number = conf['number'].to_i
words = []
arr = []
number.times{|i| arr << i}
Parallel.each(arr, in_threads:10) {|i|
  url = wiki_url.sample(1).first
  charset = nil
  html = open(url) do |f|
    charset = f.charset
    f.read
  end
  doc = Nokogiri::HTML.parse(html, nil, charset)

  word = doc.xpath('//h1[@id="firstHeading"]').inner_text
  words << word
}

CSV.open(conf['write_filename'], "a") do |csv|
    csv << words
end