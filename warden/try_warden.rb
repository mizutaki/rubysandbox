require "sinatra"
require "warden"

# Sinatra のセッションを有効にする
enable :sessions

# ユーザー ID をもとにユーザー情報を取得する
# 今回は単なる Hash だけど、実際の開発ではデータベースから取得するはず
Warden::Manager.serialize_from_session do |id|
	  { :name => id, :password => "test" }
end

# ユーザー情報からセッションに格納する ID を取り出す
Warden::Manager.serialize_into_session do |user|
	  user[:name]
end

# ユーザー名 test、パスワード test のときだけログイン成功にする
# 認証方式を登録。
# 実際に開発するときは、データベースに保存しているユーザー情報と
# 照合するなり、OAuth 使うなりするはず。
Warden::Strategies.add :login_test do
  # 認証に必要なデータが送信されているか検証
  def valid?
    params["name"] || params["password"]
  end

  # 認証
  def authenticate!
    if params["name"] == "test" && params["password"] == "test"
      # ユーザー名とパスワードが正しければログイン成功
      user = {
        :name => params["name"],
        :password => params["password"]
      }
      success!(user)
    else
    # ユーザー名とパスワードのどちらかでも間違っていたら
    # ログイン失敗
      fail!("Could not log in")
		end
  end
end

# Warden の設定
use Warden::Manager do |manager|
  # 先ほど登録したカスタム認証方式をデフォルトにする
  manager.default_strategies :login_test

  # 認証に失敗したとき呼び出す Rack アプリを設定(必須)
  manager.failure_app = Sinatra::Application
end

# ログインしていないときは、ログインフォームを表示。
# ログインしているときは、ログイン済ページを表示。
get "/" do
  if request.env["warden"].user.nil?
    erb :login
  else
    erb :success_login
  end
end

# 認証を実行する。
# 成功すればトップページに移動。
post "/login" do
	request.env["warden"].authenticate!
  redirect "/"
end

# 認証に失敗したとき呼ばれるルート。
# ログイン失敗ページを表示してみる。
post "/unauthenticated" do
	erb :fail_login
end

# ログアウトする。
# ログアウト後はトップページに移動。
get "/logout" do
	request.env["warden"].logout
	redirect "/"
end
