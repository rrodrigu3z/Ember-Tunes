# Ember Tunes
# 
# EmberJS port of Backbone Tunes app created to
# learn Backbone.JS with the Peepcode BackboneJS Screencasts
# http://peepcode.com/products/backbone-js

window.App = Ember.Application.create
  ready: ->
    App.albumsController.load()
    @_super()

# class App.Album extends Ember.Object ¿feo?
App.Album = Em.Object.extend
  title: null
  artist: null
  tracks: []
  isFirstTrack: (trackIndex) ->
    trackIndex is 0
  isLastTrack: (trackIndex) ->
    trackIndex >= @get('tracks').length - 1
  trackUrlAtIndex: (trackIndex) ->
    @get('tracks')[trackIndex]?.url
      
  
App.albumsController = Em.ArrayController.create
  content: []
  url: "/albums"
  addAlbum: (albumData) ->
    albumData.tracks = albumData.tracks.map (item, index, self) ->
      Em.Object.create(item)
    @pushObject(App.Album.create(albumData))
  load: ->
    $.getJSON @url, (data) ->
      App.albumsController.addAlbum(albumData) for albumData in data

App.player = Em.Object.create
  currentAlbumIndex: null
  currentTrackIndex: null
  state: 'stop'
  
  reset: ->
    @set 'state', 'stop'
    @set 'currentTrackIndex', null
    @set 'currentAlbumIndex', null
    
  play: ->
  pause: ->
  nextTrack: ->
  prevTrack: ->


App.playlistController = Em.ArrayProxy.create
  content: []
  playerBinding: 'App.player'
  currentAlbumIndexBinding: 'App.player.currentAlbumIndex'
  currentTrackIndexBinding: 'App.player.currentTrackIndex'
  
  # TODO: Test
  currentAlbumIndexChanged: Em.observer ->
    if @get('currentAlbumIndex') isnt null
      @get('currentAlbum')?.set('isSelected', yes)
  ,'currentAlbumIndex'
    
  # TODO: Test
  currentTrackIndexChanged: Em.observer ->
    if @get('currentTrackIndex') isnt null
      @get('currentTrack')?.set('isSelected', yes)
  ,'currentTrackIndex'
  
  
  addAlbum: (album) ->
    if @filterProperty('title', album.get('title')).length is 0
      album.get('tracks').setEach 'isSelected', no
      @pushObject album
      
      # TODO: Test
      # Selects first album and track if this is the first album added
      if @get('content').length is 1
        @set('currentAlbumIndex', 0)
        @set('currentTrackIndex', 0)
        
  addToPlaylist: (button) ->
    @addAlbum button.getPath('parentView.album')
    
  removeFromPlaylist: (button) ->
    album = button.getPath('parentView.album')    
    # TODO: Test and implement when album is current, etc.
    if @get('content').length is 1
      @get('player').reset()
    else
      @set('currentAlbumIndex', 0)
      @set('currentTrackIndex', 0)
      
    @removeObject album
    
  currentAlbum: Ember.computed ->
    @get('content')[@get('currentAlbumIndex')]
  .property()
    
  currentTrack: Ember.computed ->
    trackIndex = @get('currentTrackIndex')
    @get('currentAlbum')?.get('tracks')[trackIndex]
  .property()
  
  isCurrentAlbumFirst: ->
    @get('currentAlbumIndex') is 0
    
  isCurrentAlbumLast: ->
    @get('currentAlbumIndex') >= @get('content').length - 1
  
  # primero  | ultimo | 
  #     1       0       sumar 1 --
  #     0       1       (ir a 1er album)
  #     0       0       sumar 1 --
  #     1       1       no hacer nada
  nextAlbum: ->
    currentAlbumIndex = @get('currentAlbumIndex')
    newIndex = currentAlbumIndex
    unless @isCurrentAlbumLast()
      newIndex++  # Next Album
    else 
      newIndex = 0 unless @isCurrentAlbumFirst()
    
    if currentAlbumIndex isnt newIndex  
      @get('currentAlbum').set('isSelected', no)
      @set('currentAlbumIndex', newIndex)
    # Next Album is Always first track!
    @set 'currentTrackIndex', 0
  
  # primero  | ultimo | 
  #     1       0       ir al último
  #     0       1       restar 1
  #     0       0       restar 1
  #     1       1       no hacer nada
  prevAlbum: ->
    currentAlbumIndex = @get('currentAlbumIndex')
    newIndex = currentAlbumIndex
    unless @isCurrentAlbumFirst()
      newIndex--  # Prev Album
    else 
      newIndex = @get('content').length - 1 unless @isCurrentAlbumLast()
    
    if currentAlbumIndex isnt newIndex
      @get('currentAlbum').set('isSelected', no)
      @set('currentAlbumIndex', newIndex)
    # Prev Album is Always last track!
    @set 'currentTrackIndex', @get('currentAlbum').get('tracks').length - 1
    
  nextTrack: ->
    currentTrackIndex = @get('currentTrackIndex')
    # unselect current Track
    @get('currentTrack').set('isSelected', no)
    # Last track on Album
    if @get('currentAlbum').isLastTrack(currentTrackIndex)
      @nextAlbum() # Next Album and set track to 0! w00t!
    else # Same album
      @set 'currentTrackIndex', currentTrackIndex + 1 # just increment track
    
  prevTrack: ->
    currentTrackIndex = @get('currentTrackIndex')
    # unselect current Track
    @get('currentTrack').set('isSelected', no) 
    # Last track on Album
    if @get('currentAlbum').isFirstTrack(currentTrackIndex)
      @prevAlbum() # Prev Album and set track to last track! w00t!
    else # Same album
      @set 'currentTrackIndex', currentTrackIndex - 1 # just go to prev track
    # select new current Track

App.playlistController.addObserver 'content.length', ->
  @get('currentAlbum')?.set('isSelected', yes)
  @get('currentTrack')?.set('isSelected', yes)

App.LibraryView = Em.View.extend()

App.AlbumsView = Em.View.extend
  tagName: "ul"
  templateName: 'albums'
  albumsBinding: 'App.albumsController.content'
      
App.AlbumView = Em.View.extend
  templateName: 'album'
  classNames: ['album']
  classNameBindings: ['isSelected:current']
  
App.PlaylistView = Em.View.extend
  albumsView: App.AlbumsView.extend
    albumsBinding: 'App.playlistController.content'
    
App.QueueAlbumButton = Em.Button.extend
  target: 'App.playlistController'
