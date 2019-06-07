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
  km: 70,
  description: "Drinking beers and eating waffles, all while exploring the city's beautiful streets, nothing's better !",
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
  km: 180,
  description: "Rotterdam has the best shopping malls ! I have spent too much of my budget here, but it was worth it =)",
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
  km: 800,
  description: "For me who loves to read, Odense was a wonderful place ! I had the chance to discover more about Hans Christian Andersen and his literary works. There is also tons of cute coffee shops in the streets.",
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
  description: "I'm really glad I went to Hamburg, as it is often overlooked for Berlin. Culture is so rich here, so many museums. And people are really nice and helpful. I also went to this great music festival, it was awesome !",
  km: 315,
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
  description: "The nightlife was amazing ! Berlin's nights are completely up to their reputations. And during the day, there's still a lot to do and it's really easy to go everywhere by bike. I especially liked the East Side Gallery",
  km: 290,
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
  description: "Stuttgart has Europe's nicest library ! Besides, the countless castles around the city make for great day trips. And obviously, the Mercedes-Benz Museum is a must !",
  km: 635,
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
  description: "Before coming to Zurich, I didn't know much about Switzerland. But Zurich should be on everyone's to-do list ! Everyday I went to the lake, it's such a beautiful sight. And obviously, the Rheinfall are quite amazing to see.",
  km: 220,
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
  km: 220,
  )
