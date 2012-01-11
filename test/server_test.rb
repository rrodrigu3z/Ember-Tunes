require './test/test_helper'

class EmberTunesTest < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    EmberTunes
  end
  
  def test_index_success
    get "/"
    assert last_response.ok?
  end
  
  def test_index_include_html_headers
    get "/"
    assert_equal("text/html;charset=utf-8", last_response.headers["Content-type"])
  end
  
  def test_index_include_container
    get "/"
    assert last_response.match(/id=\"container\"/), "#container must exists"
  end
  
  def test_index_include_js_files
    get "/"
    assert last_response.match(/jquery\.js/),       "must include jquery.js"
    assert last_response.match(/underscore\.js/),   "must include underscore.js"
    assert last_response.match(/ember\.js/),        "must include ember.js"
    assert last_response.match(/ember_tunes\.js/),  "must include ember_tunes.js"
  end
  
  def test_albums_success
    get "/albums"
    assert last_response.ok?
  end
  
  def test_albums_include_json_headers
    get "/albums"
    assert_equal("application/json;charset=utf-8", last_response.headers["Content-type"])
  end
  
end