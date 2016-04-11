require 'rspotify'
require 'fuzzy_match'

artist, album = ARGV
artists = RSpotify::Artist.search(artist, market: 'US')
spotify_artist = artists.first

if spotify_artist.nil?
  fail "#{artist} does not appear to be on spotify"
end

matcher = FuzzyMatch.new(spotify_artist.albums, :read => :name)
spotify_album = matcher.find(album)

