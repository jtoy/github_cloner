require "octokit"
require 'fileutils'
searchterm= ARGV[0]
client = Octokit::Client.new( auto_traversal: true,per_page:1000)
r = client.search_repositories(searchterm)
FileUtils.mkdir_p(searchterm)
puts r.items.size
puts r.to_h.keys
total =r['total_count']
counter = 0
next_url =  client.last_response.rels[:next]
items = r.items
while items
  items.each do |item|
    url = item['clone_url']
    puts "cloning #{url}"
    `cd #{searchterm} && git clone #{url}`
    counter +=1
  end
  if client.last_response.rels[:next]
    items = client.last_response.rels[:next].get.data.items
  else
    items = nil
  end
end
