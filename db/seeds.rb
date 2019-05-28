require 'json'
require 'open-uri'

puts "Destroy all"
Destination.destroy_all
User.destroy_all

puts "Getting destinations from API"

def url(country)
 "https://www.triposo.com/api/20181213/location.json?part_of=#{country}&tag_labels=city&count=10&order_by=-score&fields=name,coordinates,snippet,country_id,score,type,images#{ENV['TRIPOSO_API_KEY']}"
end

url = url("France".downcase)
destinations_json = open(url).read
destinations = JSON.parse(destinations_json)["results"]

puts "Iterating and create destinations"

destinations.each do |destination|
  Destination.create!(
    name: destination["name"],
    description: destination["snippet"],
    photo_url: destination["images"][0]["sizes"]["medium"]["url"],
    category: destination["type"],
    score: destination["score"],
    latitude: destination["coordinates"]["latitude"],
    longitude: destination["coordinates"]["longitude"],
    country: destination["country_id"]
  )
end

