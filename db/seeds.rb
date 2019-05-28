require 'json'
require 'open-uri'

puts "Destroy all"
Destination.destroy_all
User.destroy_all

puts "Getting destinations from API"

url = 'france.json'
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
