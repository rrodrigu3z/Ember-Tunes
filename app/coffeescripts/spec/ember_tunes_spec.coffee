#Spec app
fixtures = window.fixtures ? {}

# Album Fixture
fixtures.albumData = [
  {
    title: "Album A"
    artist: "Artist A"
    tracks: [
      {title: "Track A", url: "/music/Album A Track A.mp3"},
      {title: "Track B", url: "/music/Album A Track B.mp3"}
    ]
  }, 
  {
    title: "Album B"
    artist: "Artist B"
    tracks: [
      {title: "Track A", url: "/music/Album B Track A.mp3"},
      {title: "Track B", url: "/music/Album B Track B.mp3"}
    ]
  }
]

describe "fixtures", ->
  # Assert that albumData has 2 albums and 2 tracks x album
  describe "albumData", ->
    it "should have 2 albums", ->
      expect(fixtures.albumData.length).toEqual 2
  
    it "should have 2 tracks per album", ->
      for album in fixtures.albumData
        expect(album.tracks.length).toEqual 2


describe "Album", ->
  beforeEach ->
    @album = App.Album.create(fixtures.albumData[0])
    
  it "populates title", ->
    expect(@album.get('title')).toEqual "Album A"
  
  it "populates artist", ->
    expect(@album.get('artist')).toEqual "Artist A"
  
  it "should have 2 tracks", ->
    expect(track.title for track in @album.tracks).toEqual ["Track A", "Track B"]

  describe "isFirstTrack", ->
    it "returns true for the first track", ->
      expect(@album.isFirstTrack(0)).toBeTruthy()
    it "returns false for other track", ->
      expect(@album.isFirstTrack(2)).toBeFalsy()

  describe "isLastTrack", ->
    it "returns true for the last track", ->
      expect(@album.isLastTrack(1)).toBeTruthy()
    it "returns false for other track", ->
      expect(@album.isLastTrack(0)).toBeFalsy()
  
  describe "trackUrlAtIndex", ->
    it "returns url for a valid track", ->
      expect(@album.trackUrlAtIndex(0)).toEqual "/music/Album A Track A.mp3"
    it "returns undefined for an invalid track", ->
      expect(@album.trackUrlAtIndex(2)).toBe undefined

describe "Player", ->
  beforeEach ->
    @player = App.player
  
  describe "on init", ->
    it "is stopped", ->
      expect(@player.get('state')).toEqual "stop"
  
    it "sets currentAlbumIndex to null", ->
      expect(@player.get('currentAlbumIndex')).toBe null
  
    it "sets currentTrackIndex to null", ->
      expect(@player.get('currentTrackIndex')).toBe null
    
  describe "playing", ->
    beforeEach ->
      @player.set 'state', 'play'
      @player.set 'currentAlbumIndex', 0
      @player.set 'currentTrackIndex', 0
    
    it "resets the player on reset", ->
      @player.reset()
      expect(@player.get('currentAlbumIndex')).toBe null
      expect(@player.get('currentTrackIndex')).toBe null
      expect(@player.get('state')).toEqual "stop"
  
  # play
  # pause
  # next
  # prev
  

describe "albumsController", ->
  it "has no albums", ->
    expect(App.albumsController.content.length).toEqual 0
  
  describe "add album", ->
    beforeEach ->
      App.albumsController.addAlbum fixtures.albumData[0]
    it "adds an album", ->
      expect(App.albumsController.content.length).toEqual 1
    it "tracks are Emmber Objects", ->
      track = App.albumsController.get('firstObject').get('tracks').get('firstObject')
      expect(track.get('url')).toBeDefined()
    

describe "playlistController", ->
  beforeEach ->
    @playlist = App.playlistController
    @playlist.set('currentAlbumIndex', 0)
    @playlist.set('currentTrackIndex', 0)
    @playlist.set('content', [])
  
  it "adds an album to the playlist", ->
    spyOn @playlist, 'addAlbum'
    album = App.Album.create(fixtures.albumData[0])
    buttonEvent = Em.Object.create {parentView:{album:album}}
    @playlist.addToPlaylist buttonEvent
    expect(@playlist.addAlbum).toHaveBeenCalledWith album
  
  describe "with albums", ->
    beforeEach ->
      for album in fixtures.albumData
        album.tracks = album.tracks.map (item, index, self) ->
          Em.Object.create(item)
        @playlist.addAlbum App.Album.create(album)
  
    it "has 2 albums", ->
      expect(@playlist.content.length).toEqual 2
      
    it "has Album A as first album", ->
      expect(@playlist.get('firstObject').get('title')).toEqual "Album A"
  
    it "has Album B as last album", ->
      expect(@playlist.get('lastObject').get('title')).toEqual "Album B"
  
    it "sets isSelected to false in all tracks", ->
      for album in @playlist
        expect(album.get('tracks').getEach('isSelected')).toEqual [no, no]
    
    it "removes an album from the playlist", ->
      album = @playlist.get('firstObject')
      @playlist.removeFromPlaylist Em.Object.create(parentView:{album:album})
      expect(@playlist.content.length).toEqual 1
    
    describe "current song on initial state", ->
      it "is Album A", ->
        currentAlbum = @playlist.get('currentAlbum')
        expect(currentAlbum.get('title')).toEqual "Album A"
        
      it "is Track A", ->
        currentTrack = @playlist.get('currentTrack')
        expect(currentTrack.get('title')).toEqual "Track A"
    
    describe "current song at no-initial state", ->
      beforeEach ->
        @playlist.set('currentAlbumIndex', 1)
        @playlist.set('currentTrackIndex', 1)
      
      it "is Album B", ->
        currentAlbum = @playlist.get('currentAlbum')
        expect(currentAlbum.get('title')).toEqual "Album B"
      
      it "is Track B", ->
        currentTrack = @playlist.get('currentTrack')
        expect(currentTrack.get('title')).toEqual "Track B"
    
    describe "isCurrentAlbumFirst", ->
      it "returns true on first Album", ->
        @playlist.set('currentAlbumIndex', 0)
        expect(@playlist.isCurrentAlbumFirst()).toBeTruthy()
        
      it "returns false on other Album", ->
        @playlist.set('currentAlbumIndex', 1)
        expect(@playlist.isCurrentAlbumFirst()).toBeFalsy()
        
    describe "isCurrentAlbumLast", ->
      it "returns true on last Album", ->
        @playlist.set('currentAlbumIndex', 1)
        expect(@playlist.isCurrentAlbumLast()).toBeTruthy()
        
      it "returns false on other Album", ->
        @playlist.set('currentAlbumIndex', 0)
        expect(@playlist.isCurrentAlbumLast()).toBeFalsy()
    
    describe "next track", ->
      it "increments within an album", ->
        @playlist.nextTrack()
        expect(@playlist.get('currentAlbumIndex')).toEqual 0
        expect(@playlist.get('currentTrackIndex')).toEqual 1
      
      it "goes to the next album", ->
        @playlist.set('currentTrackIndex', 1)
        @playlist.nextTrack()
        expect(@playlist.get('currentAlbumIndex')).toEqual 1
        expect(@playlist.get('currentTrackIndex')).toEqual 0
    
      it "wraps around to the first album if at end", ->
        @playlist.set('currentAlbumIndex', 1) # Last Album
        @playlist.set('currentTrackIndex', 1) # Last Track
        @playlist.nextTrack()
        expect(@playlist.get('currentAlbumIndex')).toEqual 0
        expect(@playlist.get('currentTrackIndex')).toEqual 0      
      
      it "select new current track", ->
        @playlist.set('currentAlbumIndex', 0)
        @playlist.set('currentTrackIndex', 0)
        @playlist.nextTrack()
        expect(@playlist.get('currentTrack').get('isSelected')).toBeTruthy()
      
      it "unselect prev track", ->
        @playlist.set('currentAlbumIndex', 0)
        @playlist.set('currentTrackIndex', 0)
        @playlist.nextTrack()
        track = @playlist.get('currentAlbum').get('tracks')[0]
        expect(track.get('isSelected')).toBeFalsy()
        
      
    describe "prev track", ->
      it "goes to the prev track within same album", ->
        @playlist.set('currentTrackIndex', 1)
        @playlist.prevTrack()
        expect(@playlist.get('currentAlbumIndex')).toEqual 0
        expect(@playlist.get('currentTrackIndex')).toEqual 0
      
      it "goes to the last track of the prev album", ->
        @playlist.set('currentAlbumIndex', 1)
        @playlist.set('currentTrackIndex', 0)
        @playlist.prevTrack()
        expect(@playlist.get('currentAlbumIndex')).toEqual 0
        expect(@playlist.get('currentTrackIndex')).toEqual 1
    
      it "wraps around to the last track and last album if at end", ->
        @playlist.set('currentAlbumIndex', 0) # First Album
        @playlist.set('currentTrackIndex', 0) # First Track
        @playlist.prevTrack()
        expect(@playlist.get('currentAlbumIndex')).toEqual 1
        expect(@playlist.get('currentTrackIndex')).toEqual 1
      
  describe "add included Album", ->
    beforeEach ->
      @album = App.Album.create(fixtures.albumData[0])
      @playlist.addAlbum @album
      
    it "returns undefined on existing album", ->
      result = @playlist.addAlbum @album
      expect(result).toBe(undefined)
    
    it "do not add an existing album", ->
      @playlist.addAlbum @album
      expect(@playlist.content.length).toEqual 1
  
  describe "player binding", ->
    it "is binded to App.player", ->
      expect(@playlist.playerBinding._from).toEqual 'App.player'
      expect(@playlist.playerBinding._to).toEqual 'player'
    
    it "has currentTrackIndex binded to player", ->
      expect(@playlist.currentTrackIndexBinding._from).toEqual 'App.player.currentTrackIndex'
      expect(@playlist.currentTrackIndexBinding._to).toEqual 'currentTrackIndex'
    
    it "has currentAlbumIndex binded to player", ->
      expect(@playlist.currentAlbumIndexBinding._from).toEqual 'App.player.currentAlbumIndex'
      expect(@playlist.currentAlbumIndexBinding._to).toEqual 'currentAlbumIndex'
    
  
describe "LibraryView", ->
  it "Should be defined", ->
    expect(App.LibraryView?).toBeTruthy()

describe "AlbumsView", ->
  beforeEach ->
    @albumsView = App.AlbumsView.create()
  
  it "is binded to App.albumsController", ->
    expect(@albumsView.albumsBinding._from).toEqual "App.albumsController.content"
    expect(@albumsView.albumsBinding._to).toEqual "albums"

  it "render albums", ->
    expect(@albumsView.templateName).toEqual "albums"
  
  it "sets tagName as ul", ->
    expect(@albumsView.tagName).toEqual "ul"
  
  
describe "AlbumView", ->
  it "render album", ->
    @albumView = App.AlbumView.create()
    expect(@albumView.templateName).toEqual "album"

  it "use class name albums", ->
    @albumView = App.AlbumView.create()
    expect(@albumView.classNames).toContain 'album'
  
  it "binds classname to isSelected property as current", ->
    @albumView = App.AlbumView.create()
    expect(@albumView.classNameBindings).toEqual ['isSelected:current']
  
  
describe "PlaylistView", ->
  it "Should be defined", ->
    expect(App.PlaylistView?).toBeTruthy()
  
  describe "albumsView", ->
    beforeEach ->
      @albumsView = App.PlaylistView.create().albumsView.create()
  
    it "is binded to App.playlistController", ->
      expect(@albumsView.albumsBinding._from).toEqual "App.playlistController.content"
      expect(@albumsView.albumsBinding._to).toEqual "albums"

    it "render albums", ->
      expect(@albumsView.templateName).toEqual "albums"
  
    it "sets tagName as ul", ->
      expect(@albumsView.tagName).toEqual "ul"
      
describe "QueueAlbumButton", ->
  beforeEach ->
    @button = App.QueueAlbumButton.create()
  
  it "sets target", ->
    expect(@button.get('target')).toEqual "App.playlistController"
  
