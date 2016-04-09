require 'koala'
require 'json'

GROUP_ID = 979761218718999

token = ARGV.last
koala = Koala::Facebook::API.new token.to_s

# Example:
# {"description"=>"Ayy lmao. Fuckin' tunes, brah\n\nROTATION:\n\nLuis Ángel Alicea Montañez\nLiz Babinecz\nJoe Binckes\nVictoria Marie Martin\nRyan Mead\nIngamar Dion Ramirez\nDean Rex Silfen\n\nNOW PLAYING: Metallica - Metallica\n\nCHOSEN BY: \nlil weezy\n\nON DECK:\nLizterine", "email"=>"979761218718999@groups.facebook.com", "icon"=>"https://static.xx.fbcdn.net/rsrc.php/v2/y8/r/XLEm6gBwZF6.png", "name"=>"One-Album-Week", "owner"=>{"name"=>"Dean Rex Silfen", "id"=>"10152607449406976"}, "privacy"=>"SECRET", "updated_time"=>"2016-03-28T15:45:46+0000", "id"=>"979761218718999"}
page_data = koala.get_page(GROUP_ID)
posts = koala.get_connections(GROUP_ID, 'feed', limit: 500)

File.open('./posts.json', 'w') { |f| f.write(JSON.dump(posts)) }

