require 'rbconfig'

module FullPathGenerator
  include RbConfig

  FILENAME_EXTENSION = %W(264 68k aac ac3 aif ani asf avi bak bas bat bmp CMD cmd COM dgca divx docx eml exe flv hdp htm jpg lnk lwo lzh m4a mda mdb mdw mht mid mka mkv moov mov mp2 mp3 mp4 mpg odt oga ogg ogm ogv ogx png psd qt sub wma wmv xpg zip zipx)

  #フルパスを作成する
  def generate_fullpath(hierarchy)
    fullpath = ""
    hierarchy.times {
      fullpath << "/"
      fullpath << random_character
      
    }
    fullpath << "/"
    fullpath << random_character
    fullpath << "."
    fullpath << FILENAME_EXTENSION.sample
    puts fullpath
    return fullpath
  end

  private
    #ランダムな文字列を作成する（10文字）
    def random_character
      return ((0..9).to_a + ("a".."z").to_a + ("A".."Z").to_a).sample(10).join
    end

    #TODO 実行環境の判定を行って、環境毎のフルパスを作成できるようにする
    def judge_enviroment
      osn = CONFIG["target_os"].downcase
    end
end