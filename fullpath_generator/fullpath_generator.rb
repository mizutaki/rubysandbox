require 'rbconfig'

module FullPathGenerator
	include RbConfig
	
	#フルパスを作成する
	def generate_fullpath(hierarchy)
		concatenate_string = ""
		hierarchy.times {
			concatenate_string << random_character
			concatenate_string << "/"
		}
    puts concatenate_string
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

include FullPathGenerator
FullPathGenerator.generate_fullpath(9)