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


describe "Player", ->
  beforeEach ->
    @player = App.Player.create()
  
  it "is stopped", ->
    expect(@player.get('state')).toEqual "stop"
  
  it "sets currentAlbumIndex to 0", ->
    expect(@player.get('currentAlbumIndex')).toEqual 0
  
  it "sets currentTrackIndex to 0", ->
    expect(@player.get('currentTrackIndex')).toEqual 0


describe "albumsController", ->
  it "has no albums", ->
    expect(App.albumsController.content.length).toEqual 0
  
  it "adds an album", ->
    App.albumsController.addAlbum fixtures.albumData[0]
    expect(App.albumsController.content.length).toEqual 1

describe "playlistController", ->
  beforeEach ->
    for album in fixtures.albumData
      App.playlistController.addAlbum album
  
  it "has Album A as first album", ->
    expect(App.playlistController.get('firstObject').get('title')).toEqual "Album A"
  
  it "has Album B as last album", ->
    expect(App.playlistController.get('lastObject').get('title')).toEqual "Album B"
  
  describe "addAlbum", ->
    it "returns undefined on existing album", ->
      result = App.playlistController.addAlbum fixtures.albumData[0]
      expect(result).toBe(undefined)
    
    it "do not add an existing album", ->
      App.playlistController.addAlbum fixtures.albumData[0]
      expect(App.playlistController.content.length).toEqual 2
    
  
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
      
