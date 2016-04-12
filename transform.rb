require 'json'
require 'yaml'
require 'rspotify'
require 'fuzzy_match'
require 'time'

class Album
  attr_accessor :date, :artist, :album
  def initialize(date, artist, album)
    @date = Time.strptime(date, "%m/%d/%y").strftime('%y-%m-%d')
    @artist = artist
    @album = album
    puts date, artist, album
  end

  def spotify_record
    search_result = RSpotify::Artist.search(artist, market: 'US')
    artist_matcher = FuzzyMatch.new(search_result, from: :name)
    spotify_artist = artist_matcher.find(artist)

    album_matcher = FuzzyMatch.new(spotify_artist.album, from: :name)
    spotify_album = album_matcher.find(album)

    spotify_album
  end

  def post
    if spotify_record.nil?
      puts  "Not found #{album}"
      return
    end
    front_matter_hash = {
      'layout' => 'post',
      'comments' => true,
      'title' => post_title,
    }
    unless spotify_record.images.empty?
      image = spotify_record.images.max{ |h| h['height'] }
      front_matter_hash['cover_url'] = image['url']
      front_matter_hash['cover_width'] = image['width']
      front_matter_hash['cover_height'] = image['height']
    end

    yaml_front = YAML.dump(front_matter_hash) + "---\n"
    body = spotify_record.embed + "\n"
    File.open('./out/' + filename, 'w') { |f| f.write(yaml_front + body) }
    puts "wrote file #{filename}"
  end

  def post_title
    "#{date} #{artist}"
  end

  def filename
    "#{@date}-#{artist.split.join('-')}-#{album.split.join('-')}.md"
  end
end

data = JSON.load(File.open('./posts.json').read)
albums = []
File.open('./albums.txt').read.split("\n").delete_if { |i| i == '' }.each_slice(2) do |records|
  title, album = records
  puts title, album
  date = title.split('-')[0].strip
  artist = album.split('-')[0].strip
  album = album.split('-')[-1].strip
  puts "working on #{album}"
  album_obj = Album.new(date, artist, album)
  album_obj.post
end

