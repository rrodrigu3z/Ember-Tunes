# Ember Tunes
# 
# EmberJS port of Backbone Tunes app created to
# learn Backbone.JS with the Peepcode BackboneJS Screencasts
# http://peepcode.com/products/backbone-js

window.App = Ember.Application.create
  ready: ->
    App.albumsController.load()

# class App.Album extends Ember.Object ¿feo?
App.Album = Em.Object.extend
  title: null
  artist: null
  tracks: []
  
App.albumsController = Em.ArrayController.create
  content: []
  url: "/albums"
  addAlbum: (albumData) ->
    @pushObject(App.Album.create(albumData))
  load: ->
    $.getJSON @url, (data) ->
      App.albumsController.addAlbum(albumData) for albumData in data

App.LibraryView = Em.View.extend()

App.AlbumsView = Em.View.extend
  templateName: 'albums'
  albumsBinding: 'App.albumsController.content'
      
App.AlbumView = Em.View.extend
  templateName: 'album'
