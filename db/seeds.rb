# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "destroy all"
Destination.destroy_all
User.destroy_all

puts "create destinations"

cities = ["Bangkok", "London", "Paris", "Singapour", "New York", "Istanbul", "Dubaï", "Kuala Lumpur", "Rome", "Lisbon", "Prague", "Pekin", "Zurich", "Barcelona", "Madrid", "Moscow", "Budapest", "Berlin", "Vienna", "Munich"]
countries = ["Thailand", "England", "France", "Singapour", "USA", "Turkey", "Dubaï", "Malaysia", "Italy", "Portugal", "Czech Republic", "China", "Switzerland", "Spain", "Spain", "Russia", "Hongary", "Germany", "Austria", "Germany"]
lorem = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Delectus ratione nam velit, a eveniet earum, fugit laudantium voluptates suscipit qui quisquam aspernatur officia repellat quaerat provident. Hic, nisi voluptates ducimus."

cities.each do |name|
  i = 0
  destination = Destination.new(name: name, description: lorem, country: country[i])
  # destination.remote_photo_url = url
  # destination.save
  i = i+1
end
