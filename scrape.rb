require 'koala'
require 'json'

GROUP_ID = 979761218718999

token = ARGV.last
koala = Koala::Facebook::API.new token.to_s
page_data = koala.get_page(GROUP_ID)
posts = koala.get_connections(GROUP_ID, 'feed', limit: 500)

File.open('./posts.json', 'w') { |f| f.write(JSON.dump(posts)) }

