require 'json'
require 'yaml'

posts = {}

data = JSON.load(File.open('./posts.json').read)

def to_markdown(filename, front_matter_hash, body)
  front_matter = YAML.dump(front_matter_hash)
  front_matter += "---\n"
  body = front_matter + body + "\n"
  File.open('./out/' + filename, 'w') { |f| f.write(body) }
end

data.each do |post|

  if post['message'].nil?
    puts "#{post['id']} has no message"
    next
  end

  front_matter_hash = { 'layout' => 'post' }
  ymd = post['created_time'][0..9]
  poster = post['from']['name']
  filename = "#{ymd}-#{poster.split.join('-')}.md"
  front_matter_hash['title'] = "#{ymd} #{poster}"
  front_matter_hash['comments'] = true
  front_matter_hash['categories'] = poster.split.last
  to_markdown(filename, front_matter_hash, post['message'])
end

