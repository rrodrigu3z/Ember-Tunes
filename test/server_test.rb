require './test/test_helper'

class EmberTunesTest < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    EmberTunes
  end
  
  def test_hello_world
    get '/'
    assert_equal('Hola Mundo!', last_response.body)
  end
end