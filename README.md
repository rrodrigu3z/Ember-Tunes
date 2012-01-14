Ember Tunes
===========

Ember Tunes is an Ember.js port of Backbone Tunes, the example app used in the Peepcode Backbone.js Screencasts (Part I and Part II).

I used this app to learn a little of Ember.js, so you may expect some things
like this when check the code:

- Maybe a little of overdoing, this was to experiment or test Ember.js features.
- Maybe a lack of Ember.js (or SproutCore) "idiomatic" implementation.
- And yes, the playlist should be binded to the player (not the player binded 
  to the playlist) but at least the player is very concise, it just plays
  an audio.

Additional Info:

- The server is based on Sinatra.
- Ruby 1.9.3.
- Coffeescript.
- Javascript generated with Basrista gem.
- Using Jasmine for Javascript tests.
- Track examples, data example, stylesheets and images were taken from the
  original Backbone Tunes by Peepcode.

The Backbone.js Screencasts by Peepcode are great, if you have some interest in
Backbone.js go to http://peepcode.com/products/backbone-js and
https://peepcode.com/products/backbone-ii and take a look!
  
Install
=======

Get the code:

Install dependencies:
  
    bundle install

USAGE
=====

Run:

    rake server

Run Server Tests:

    rake test

Visit the webserver at:

    http://localhost:9292

Run Javascript tests:

    http://localhost:9292/javascripts/spec/runner.html

