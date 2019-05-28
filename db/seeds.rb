# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'
require 'open-uri'

puts "destroy all"
Destination.destroy_all
User.destroy_all

puts "create destinations"

# cities = ["Bangkok", "London", "Paris", "Singapour", "New York", "Istanbul", "Dubaï", "Kuala Lumpur", "Rome", "Lisbon", "Prague", "Pekin", "Zurich", "Barcelona", "Madrid", "Moscow", "Budapest", "Berlin", "Vienna", "Munich"]
# countries = ["Thailand", "England", "France", "Singapour", "USA", "Turkey", "Dubaï", "Malaysia", "Italy", "Portugal", "Czech Republic", "China", "Switzerland", "Spain", "Spain", "Russia", "Hongary", "Germany", "Austria", "Germany"]
# lorem = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Delectus ratione nam velit, a eveniet earum, fugit laudantium voluptates suscipit qui quisquam aspernatur officia repellat quaerat provident. Hic, nisi voluptates ducimus."

# cities.each_with_index do |name, index|
#   destination = Destination.new(name: name, description: lorem, country: countries[index])
#   destination.photo_url = "https://res.cloudinary.com/dotvqg92r/image/upload/c_scale,h_500/v1558965633/slowtraveller/london_rrwf7y.jpg"
#   destination.save
# end
url = 'france.json'
destinations_json = open(url).read
destinations = JSON.parse(destinations_json)
destinations = destinations["results"]

puts "iterating"

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
