require 'json'
require 'open-uri'

puts "Destroy all"
Destination.destroy_all
User.destroy_all

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
      photo_url: destination["images"][0]["sizes"]["medium"]["url"],
      category: destination["type"],
      score: destination["score"],
      latitude: destination["coordinates"]["latitude"],
      longitude: destination["coordinates"]["longitude"],
      country: destination["country_id"]
    )
  end
end

create_destination("Switzerland")
create_destination("France")
create_destination("Germany")
create_destination("Italy")
create_destination("Austria")
create_destination("Belgium")
create_destination("Russia")
create_destination("Spain")
create_destination("Portugal")
create_destination("Poland")
create_destination("Greece")
