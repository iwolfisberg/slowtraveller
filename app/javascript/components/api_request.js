const getJourney = (routes_transit) => {
  const journeyResults = []
  routes_transit["routes"].forEach((journey) => {
    journeyResults.push({
      duration: journey["legs"][0]["duration"]["text"],
      carbon: total_carbon(journey["legs"][0]["steps"]) / 1000,
      connections: get_steps(journey["legs"][0]["steps"]).size,
      departure_time: journey["legs"][0]["departure_time"]["text"],
      arrival_time: journey["legs"][0]["arrival_time"]["text"],
      departure: journey["legs"][0]["start_address"],
      arrival: journey["legs"][0]["end_address"],
      steps: get_steps(journey["legs"][0]["steps"])
    });
  });
  return journeyResults;
};

const getSteps = (steps) => {
  const stepsResults = []
  steps.forEach((step) => {
    unless (step["travel_mode"] == "WALKING") {
      stepsResults.push({
          icon: step["transit_details"]["line"]["vehicle"]["icon"],
          arrival_time: step["transit_details"]["arrival_time"]["text"],
          arrival: step["transit_details"]["arrival_stop"]["name"],
          departure_time: step["transit_details"]["departure_time"]["text"],
          departure: step["transit_details"]["departure_stop"]["name"],
          duration: step["duration"]["text"],
          html_instructions: step["html_instructions"],
          agency: step["transit_details"]["line"]["agencies"][0]["name"],
          agency_url: step["transit_details"]["line"]["agencies"][0]["url"]
        });
      }
    });
  return stepsResults;
};

const departureTime = (date, time) => {
  const fullDate = `${date} ${time}`;
  const dateSeconds = Date.parse(fullDate) / 1000;

  const startDate = new Date("1970-01-01") / 1000;
  return (dateSeconds - startDate);
};



const list = document.querySelector(".content-index")

// const insertResults = (data) => {
//   data.Search.forEach((result) => {
//     const destination = "<%= j render(:partial => 'shared/card-destination-index') %>";
//     list.insertAdjacentHTML('beforeend', destination);
//   });
// };

const fetchResults = (query_location, query_date, query_time) => {
  let destinations_results = "<%= j Destination.where.not(name: location.capitalize).order(score: :desc).near(location, 1500).take(10) %>"
  const destinations_array = []
  destinations_results.forEach((destination) => {
    fetch(`https://maps.googleapis.com/maps/api/directions/json?origin=${query_location}&destination=${destination.name.normalize("NFKD").replace(/[^\x00-\x7F]/ig, '').toLowerCase()}&departure_time=${departureTime(query_date, query_time)}&mode=transit&alternatives=true&key=${ENV['GOOGLE_API_KEY']}`)
      .then(response => response.json())
      .then(insertResults);

      const results = { id: destination.id, name: destination.name, country: destination.country, photo_url: destination.photo_url, description: destination.description, journeys: get_journey(@routes_transit) } unless @routes_transit.keys[0] == "available_travel_modes"
      destinations_array << results unless results.nil?
  });
};



const form = document.querySelector('.form-search');
form.addEventListener('submit', (event) => {
  event.preventDefault();
  list.innerHTML = '';
  const location_input = document.querySelector('#_destinations_location');
  const date_input = document.querySelector('#_destinations_departure_day');
  const time_input = document.querySelector('#_destinations_departure_time');
  fetchResults(location_input.value, date_input.value, time_input.value);
});

















