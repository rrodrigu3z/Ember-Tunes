require "./lib/init"

class EmberTunes < Sinatra::Base
  register Barista::Integration::Sinatra
  set :root, File.dirname(__FILE__) + "/../"
  
  get '/' do
    send_file "public/index.html", :type => 'text/html', :disposition => 'inline'
  end
  
  get '/albums' do
    content_type "application/json"
    File.readlines("public/albums.json")
  end
end