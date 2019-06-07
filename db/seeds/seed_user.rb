puts "Destroy favorites"
Favorite.destroy_all
puts "Destroy steps"
Step.destroy_all
puts "Destroy users"
User.destroy_all

puts "Creating user Justine"
justine = User.create!(
  email: "justine@gmail.com",
  password: "secret",
    )

puts "Creating step 1"
destination = Destination.where(country: "Belgium", name: "Bruges")
Step.create!(
  user_id: justine.id,
  destination_id: destination[0][:id],
  departure: "Lille, France",
  arrival: "Bruges, Belgium",
  carbon: 4,
  arrival_day: "10.04.2019",
  description: "Boire des bières et manger des gauffres, tout en explorant les belles rues historiques de la ville, rien de mieux ! "
  )

puts "Creating step 2"
destination = Destination.where(country: "Netherlands", name: "Rotterdam")
Step.create!(
  user_id: justine.id,
  destination_id: destination[0][:id],
  departure: "Bruges, Belgium",
  arrival: "Rotterdam, Netherlands",
  carbon: 5,
  arrival_day: "14.04.2019",
  description: destination[0][:description]
  )

puts "Creating step 3"
destination = Destination.where(country: "Denmark", name: "Odense")
Step.create!(
  user_id: justine.id,
  destination_id: destination[0][:id],
  departure: "Rotterdam, Netherlands",
  arrival: "Odense, Denmark",
  carbon: 9,
  arrival_day: "20.04.2019",
  description: destination[0][:description]
  )

puts "Creating step 4"
destination = Destination.where(country: "Germany", name: "Hamburg")
Step.create!(
  user_id: justine.id,
  destination_id: destination[0][:id],
  departure: "Odense, Denmark",
  arrival: "Hamburg, Germany",
  carbon: 10,
  arrival_day: "25.04.2019",
  description: destination[0][:description],
  )

puts "Creating step 5"
destination = Destination.where(country: "Germany", name: "Berlin")
Step.create!(
  user_id: justine.id,
  destination_id: destination[0][:id],
  departure: "Hamburg, Germany",
  arrival: "Berlin, Germany",
  carbon: 8,
  arrival_day: "01.05.2019",
  description: "Incroyable vie nocturne ! Les nuits berlinoises ne sont définitivement pas un mythe. Et la journée, plein de choses à voir tout en circulant à vélo dans la ville."
  )

puts "Creating step 6"
destination = Destination.where(country: "Germany", name: "Stuttgart")
Step.create!(
  user_id: justine.id,
  destination_id: destination[0][:id],
  departure: "Berlin, Germany",
  arrival: "Stuttgart, Germany",
  carbon: 12,
  arrival_day: "25.05.2019",
  description: destination[0][:description],
  )

puts "Creating step 7"
destination = Destination.where(country: "Switzerland", name: "Zurich")
Step.create!(
  user_id: justine.id,
  destination_id: destination[0][:id],
  departure: "Stuttgart, Germany",
  arrival: "Zurich, Switzerland",
  carbon: 10,
  arrival_day: "31.05.2019",
  description: "Stuttgart a la plus jolie bibliothèque d'Europe ! En plus, les nombreux châteaux dans les environs"
  )

puts "Creating step 8"
destination = Destination.where(country: "Switzerland", name: "Lausanne")
Step.create!(
  user_id: justine.id,
  destination_id: destination[0][:id],
  departure: "Zurich, Switzerland",
  arrival: "Lausanne, Switzerland",
  carbon: 5,
  arrival_day: "04.06.2019",
  description: destination[0][:description],
  )
