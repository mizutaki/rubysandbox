require 'pstore'
require 'webrick'
class Page
	def initialize
		@@current_page = 1
		@db = PStore.new('pstore', true)
	end
	def get_current_page
		@@current_page
	end
	#投稿日時降順で取得する
	def get_page
		@db.transaction{ |pstore|
			tmp = all_desc(pstore)
			get_message(tmp)
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
		count = 0
		desc_hash = {}
		new_arr.each do |key|
			value = pstore.fetch(key)
			desc_hash[count+=1] = value
		end
		return desc_hash
	end

	# 指定されたページのメッセージ内容を取得する
	def get_message(desc_hash)
		start_range = @@current_page * 10 - 9
		end_range = @@current_page * 10
		range = Range.new(start_range, end_range)
		message_list = {}
		range.each do |key|
			value = desc_hash[key]
			message_list[key] = value
		end
		return message_list
	end

	#現在のページの次のページを取得する
	def next_page
		@@current_page += 1
		get_page
	end

	#現在のページの前のページを取得する
	#現在が1ページ目なら何もしない
	def privious_page
		return if @@current_page == 1
		@@current_page -= 1
		get_page
	end

	private :all_asc,:all_desc,:get_message
end