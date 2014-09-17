require 'pstore'
class Order
    def self.desc_order
        db = PStore.new('pstore', true)
        db.transaction { |pstore|
            keys = []
            keys << pstore.roots #全キーを取得（昇順）
            new_arr = []
            keys.first.map { |key|
                new_arr.unshift(key)#全キーを降順に入れ替え
            }
            result = {}
            new_arr.each do |key|
                value = pstore.fetch(key)
                result[key] = value
            end
            return result
        }
    end
end