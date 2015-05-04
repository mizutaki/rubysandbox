require 'rbconfig'
require 'csv'
require 'open-uri'
require 'nokogiri'

module FullPathGenerator
  include RbConfig

  FILENAME_EXTENSION = %W(264 68k aac ac3 aif ani asf avi bak bas bat bmp CMD cmd COM dgca divx docx eml exe flv hdp htm jpg lnk lwo lzh m4a mda mdb mdw mht mid mka mkv moov mov mp2 mp3 mp4 mpg odt oga ogg ogm ogv ogx png psd qt sub wma wmv xpg zip zipx)

  #フルパスを作成して、ファイルに書き込む
  def generate_fullpath(number)
    file_name = get_file_name(".txt")
    fullpaths = get_fullpaths(number)
    fullpaths.each do |fullpath|
      write_file(file_name, fullpath)
    end
  end

  #フルパスを作成して、CSVファイルに書き込む
  def generate_fullpath_csv(number)
    file_name = get_file_name(".csv")
    fullpaths = get_fullpaths(number)
    write_file_csv(file_name, fullpaths)
  end

  private
    #フルパスを書き出すファイルの名前を取得する
    #連番で振られていく
    def get_file_name(filename_extension)
      rename = ""
      contents = Dir::entries(".")
      0.upto(contents.length) {|num|
        if num == 0
          content_name = "fullpaths" + filename_extension
        else
          content_name = "fullpaths_" + num.to_s + filename_extension
        end
        unless contents.include?(content_name)
          rename = content_name
          break
        end
      }
      return rename
    end

    #フルパスを作成して、フルパスのリストを返す
    def get_fullpaths(number)
      fullpaths = []
      number.times {
        fullpath = ""
        10.times {
          fullpath << "/"
          fullpath << random_word
        }
        fullpath << "/"
        fullpath << random_word
        fullpath << "."
        fullpath << FILENAME_EXTENSION.sample
        fullpaths << fullpath
      }
      return fullpaths
    end

    #ファイルに追記型で書き込む
    def write_file(file_name, fullpath)
      File.open(file_name, "a") do |file|
        file.puts fullpath
      end
    end

    def write_file_csv(file_name, fullpaths)
      CSV.open(file_name, "a") do |writer|
        writer << fullpaths
      end
    end

    #ランダムな文字列を作成する
    #wikipediaよりランダムに単語を抽出する
    def random_word
      #str = ((0..9).to_a + ("a".."z").to_a + ("A".."Z").to_a + ("あ".."ん").to_a)
      wiki_url = ["http://wikipedia.org/wiki/Special:Randompage", "http://ja.wikipedia.org/wiki/Special:Randompage"]
      url = wiki_url.sample(1).first
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)
      word = doc.xpath('//h1[@id="firstHeading"]').inner_text
      return word
    end

    #TODO 実行環境の判定を行って、環境毎のフルパスを作成できるようにする
    def judge_enviroment
      osn = CONFIG["target_os"].downcase
    end
end