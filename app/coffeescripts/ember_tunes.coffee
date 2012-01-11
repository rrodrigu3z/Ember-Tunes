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

App.Player = Em.Object.extend
  currentAlbumIndex: 0
  currentTrackIndex: 0
  state: 'stop'

App.albumsController = Em.ArrayController.create
  content: []
  url: "/albums"
  addAlbum: (albumData) ->
    @pushObject(App.Album.create(albumData))
  load: ->
    $.getJSON @url, (data) ->
      App.albumsController.addAlbum(albumData) for albumData in data

App.playlistController = Em.ArrayProxy.create
  content: []
  addAlbum: (albumData) ->
    @pushObject(App.Album.create(albumData)) if @filterProperty('title', albumData.title).length == 0

App.LibraryView = Em.View.extend()

App.AlbumsView = Em.View.extend
  tagName: "ul"
  templateName: 'albums'
  albumsBinding: 'App.albumsController.content'
      
App.AlbumView = Em.View.extend
  templateName: 'album'

App.PlaylistView = Em.View.extend
  albumsView: App.AlbumsView.extend
    albumsBinding: 'App.playlistController.content'

