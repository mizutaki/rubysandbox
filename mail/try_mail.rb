require 'sinatra'
require 'pony'
require 'yaml'

config = YAML.load_file('config.yml')
get '/test_text' do
  Pony.mail(
	  :to => config['mail']['to'],
	  :subject => "件名",
	  :body => erb(:test_mailer),
	  :via => :smtp,
	  :via_options => {
	    :enable_starttls_auto => true,
		  :address => config['mail']['address'],
		  :port => config['mail']['port'],
		  :user_name => config['mail']['username'],
		  :password => config['mail']['password'],
		  :authentication => :plain,
		  :domain => config['mail']['domain']
    }
  )
end

get '/test_html' do
  Pony.mail(
	  :to => config['mail']['to'],
	  :subject => "件名",
	  :html_body => erb(:test_mailer2),
	  :via => :smtp,
	  :via_options => {
	  	:enable_starttls_auto => true,
		  :address => config['mail']['address'],
		  :port => config['mail']['port'],
		  :user_name => config['mail']['username'],
		  :password => config['mail']['password'],
		  :authentication => :plain,
		  :domain => config['mail']['domain']
    }
  )
end
