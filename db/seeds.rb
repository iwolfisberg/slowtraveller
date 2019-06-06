require 'json'
require 'open-uri'
require_relative 'countries'

puts "Destroy destinations"
Destination.destroy_all

def url(country)
 "https://www.triposo.com/api/20181213/location.json?part_of=#{country.capitalize}&tag_labels=city&count=10&order_by=-score&fields=name,coordinates,snippet,country_id,score,type,images#{ENV['TRIPOSO_API_KEY']}"
end

def create_destination(country)
  puts "Creating destinations for #{country}"
  url = url(country)
  destinations_json = open(url).read
  destinations = JSON.parse(destinations_json)["results"]
  destinations.each do |destination|
    Destination.create!(
      name: destination["name"],
      description: destination["snippet"],
      photo_url_medium: destination["images"][0]["sizes"]["medium"]["url"],
      photo_url_small: destination["images"][0]["sizes"]["thumbnail"]["url"],
      category: destination["type"],
      score: destination["score"],
      latitude: destination["coordinates"]["latitude"],
      longitude: destination["coordinates"]["longitude"],
      country: destination["country_id"]
    )
  end
end

COUNTRIES.each do |country|
  create_destination(country)
end
