require 'rbconfig'

module FullPathGenerator
  include RbConfig

  FILENAME_EXTENSION = %W(264 68k aac ac3 aif ani asf avi bak bas bat bmp CMD cmd COM dgca divx docx eml exe flv hdp htm jpg lnk lwo lzh m4a mda mdb mdw mht mid mka mkv moov mov mp2 mp3 mp4 mpg odt oga ogg ogm ogv ogx png psd qt sub wma wmv xpg zip zipx)

  #フルパスを作成して、ファイルに書き込む
  def generate_fullpath(number)
    file_name = get_file_name
    number.times {
      fullpath = ""
      10.times {
        fullpath << "/"
        fullpath << random_character
      }
      fullpath << "/"
      fullpath << random_character
      fullpath << "."
      fullpath << FILENAME_EXTENSION.sample
      write_file(file_name,fullpath)
    }
  end

  private
    #フルパスを書き出すファイルの名前を取得する
    #連番で振られていく
    def get_file_name
      rename = ""
      contents = Dir::entries(".")
      0.upto(contents.length) {|num|
        if num == 0
          content_name = "fullpaths.txt"
        else
          content_name = "fullpaths_" + num.to_s + ".txt"
        end
        unless contents.include?(content_name)
          rename = content_name
          break
        end
      }
      return rename
    end

    #ファイルに追記型で書き込む
    def write_file(file_name, fullpath)
      File.open(file_name, "a") do |file|
        file.puts fullpath
      end
    end

    #ランダムな文字列を作成する（10文字）
    def random_character
      return ((0..9).to_a + ("a".."z").to_a + ("A".."Z").to_a + ("あ".."ん").to_a + ("亜".."和").to_a).sample(10).join
    end

    #TODO 実行環境の判定を行って、環境毎のフルパスを作成できるようにする
    def judge_enviroment
      osn = CONFIG["target_os"].downcase
    end
end