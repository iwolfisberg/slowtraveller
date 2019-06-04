require 'json'
require 'open-uri'
require_relative 'countries'


puts "Destroy favorites"
Favorite.destroy_all
puts "Destroy steps"
Step.destroy_all
puts "Destroy destinations"
Destination.destroy_all
puts "Destroy users"
User.destroy_all

puts "Creating user"
toto = User.create!(email: validate1@gmail.com, password: "123456")

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

COUNTRIES.each do |country|
  create_destination(country)
end

puts "Creating steps"
# Step.create!(
#   user_id: toto.id,
#   destination_id: Destination.where("name = ? and country = ?", "Florence", "Italy")[0][:id],
#   departure: "Lausanne, Switzerland",
#   arrival: "Florence, Italy",
#   arrival_day: "01.04.2019",
#   description: "Florence was amazing to discover. The museum, the people, everything is nice !"
#   )

# Step.create!(
#   user_id: toto.id,
#   destination_id: Destination.where("name = ? and country = ?", "Vienna", "Austria")[0][:id],
#   departure: "Florence, Italy",
#   arrival: "Vienna, Austria",
#   arrival_day: "26.04.2019",
#   description: "Vienna has so much history and the best schnitzel !!"
#   )

# Step.create!(
#   user_id: toto.id,
#   destination_id: Destination.where("name = ? and country = ?", "Warsaw", "Poland")[0][:id],
#   departure: "Vienna, Austria",
#   arrival: "Warsaw, Poland",
#   arrival_day: "15.05.2019",
#   description: "Known for music and shows. Recommended places to visit are Copernicus Science Centre, Łazienki Park and Warsaw Uprising Museum."
#   )

# Step.create!(
#   user_id: toto.id,
#   destination_id: Destination.where("name = ? and country = ?", "Riga", "Latvia")[0][:id],
#   departure: "Warsaw, Poland",
#   arrival: "Riga, Latvia",
#   arrival_day: "30.05.2019",
#   description: "The capital city of Latvia and the European Capital of Culture in 2014 with a long history"
#   )
