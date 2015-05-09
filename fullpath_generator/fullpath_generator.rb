require 'rbconfig'
require 'csv'
#require 'open-uri'
#require 'nokogiri'
require 'yaml'

module FullPathGenerator
  include RbConfig

  FILENAME_EXTENSION = %W(264 68k aac ac3 aif ani asf avi bak bas bat bmp CMD cmd COM dgca divx docx eml exe flv hdp htm jpg lnk lwo lzh m4a mda mdb mdw mht mid mka mkv moov mov mp2 mp3 mp4 mpg odt oga ogg ogm ogv ogx png psd qt sub wma wmv xpg zip zipx)
  EXTENSION_TXT = ".txt"
  EXTENSION_CSV = ".csv"

  @conf = YAML.load_file("fg_conf.yml")

  #フルパスを作成して、ファイルに書き込む
  def generate_fullpath(number)
    file_name = get_file_name(EXTENSION_TXT)
    fullpaths = get_fullpaths(number)
    fullpaths.each do |fullpath|
      write_file(file_name, fullpath)
    end
  end

  #フルパスを作成して、CSVファイルに書き込む
  def generate_fullpath_csv(number)
    file_name = get_file_name(EXTENSION_CSV)
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
      hierarchy = @conf["hierarchy"].to_i + 1
      number.times {
        fullpath = ""
        datas = read_sample_data(hierarchy)
        hierarchy.times { |num|
          fullpath << "/"
          fullpath << datas[num]
        }
        fullpath << "/"
        fullpath << datas[datas.last.to_i]
        fullpath << "."
        fullpath << FILENAME_EXTENSION.sample
        fullpaths << fullpath
      }
      return fullpaths
    end

    #sample_dataを読み込んでnumber分の単語を取得する
    def read_sample_data(number)
      datas = CSV.read(@conf["sample_data_file"]).flatten.sample(number)
      return datas
    end

    #ファイルに追記型で書き込む
    def write_file(file_name, fullpath)
      File.open(file_name, "a") do |file|
        file.puts fullpath
      end
    end

    #CSVファイルに追記型で書き込む
    def write_file_csv(file_name, fullpaths)
      CSV.open(file_name, "a") do |writer|
        writer << fullpaths
      end
    end

    #TODO 実行環境の判定を行って、環境毎のフルパスを作成できるようにする
    def judge_enviroment
      osn = CONFIG["target_os"].downcase
    end
end