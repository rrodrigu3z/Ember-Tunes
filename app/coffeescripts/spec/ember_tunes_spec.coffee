#Spec app
fixtures = window.spec ? {}

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
      _(fixtures.albumData).each (album) ->
        expect(album.tracks.length).toEqual 2


