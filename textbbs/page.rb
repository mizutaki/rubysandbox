require 'pstore'
class Page
	def initialize
		@current_page = 1
		@db = PStore.new('pstore', true)
	end
	
	#デフォルトでは、降順で取得する
	def order
		@db.transaction{ |pstore|
			all_desc(pstore)
		}
	end

	#全投稿内容を昇順で取得する
	def all_asc(pstore)
		keys = []
		keys = pstore.roots
		asc_hash = {}
		keys.each do |key|
			value = pstore.fetch(key)
			asc_hash[key] = value
		end
		return asc_hash
	end

	#全投稿内容を降順で取得する
	def all_desc(pstore)
		keys = []
		keys << pstore.roots #全キーを取得（昇順）
		new_arr = []
		keys.first.map { |key|
			new_arr.unshift(key)#全キーを降順に入れ替え
		}
		desc_hash = {}
		new_arr.each do |key|
		value = pstore.fetch(key)
		desc_hash[key] = value
		end
		return desc_hash
	end

	# 指定されたページのメッセージ内容を取得する
	def get_page(pstore)
		# not implemented
	end

	#現在のページの次のページを取得する
	def next_page
		@current_page += 1
		p @current_page
	end

	#現在のページの前のページを取得する
	#現在が1ページ目なら何もしない
	def privious_page
		return if @current_page == 1
		@current_page -= 1
		p @current_page
	end

	private :all_asc,:all_desc,:get_page
end