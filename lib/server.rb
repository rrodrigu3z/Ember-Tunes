require "./lib/init"

class EmberTunes < Sinatra::Base
  register Barista::Integration::Sinatra
  set :root, File.dirname(__FILE__) + "/../"
  
  # TODO: for now, this is just test
  get '/' do
    'Hola Mundo!'
  end
end