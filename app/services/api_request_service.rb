class ApiRequestService
  def self.google_api_request(user_destination_id, location, day, time, current_user)
    if user_destination_id != ""
      destination_user_choice = Destination.find(user_destination_id.to_i)
      array = []
      array << parse_api(destination_user_choice, location, day, time) unless parse_api(destination_user_choice, location, day, time).nil?
      array
    else
      destinations_results = (Destination.where.not(name: location.capitalize).where("score >= ?", 7).near(location, 1000, min_radius: 400) - Step.where(user: current_user).all).take(10)  #.shuffle
      array = []
      destinations_results.each do |destination|
        array << parse_api(destination, location, day, time) unless parse_api(destination, location, day, time).nil?
      end
      array
    end
  end

  private

  def self.parse_api(destination, location, day, time)
    url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{location}&destination=#{destination.name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').downcase.to_s}&departure_time=#{departure_time(day, time)}&mode=transit&alternatives=true&key=#{ENV['GOOGLE_API_KEY']}"
    routes = JSON.parse(open(url).read)
    results = { id: destination.id, name: destination.name, country: destination.country, photo_url_small: destination.photo_url_small, photo_url_medium: destination.photo_url_medium, description: destination.description, journeys: get_journey(routes, day, time) } unless routes.keys[0] == "available_travel_modes"
    results
  end

  def self.get_journey(routes_transit, day_user, time_user)
    journey_results = []
    price = rand(80..130)
    routes_transit["routes"].each do |journey|
      journey_results << {
                          modes_icones: modes_icones(journey["legs"][0]["steps"]),
                          duration: seconds_to_hmin(journey["legs"][0]["duration"]["value"]),
                          carbon: total_carbon(journey["legs"][0]["steps"]) / 1000,
                          connections: get_steps(journey["legs"][0]["steps"]).size - 1,
                          departure_time: seconds_to_hm(journey["legs"][0]["departure_time"]["value"]),
                          arrival_time: seconds_to_hm(journey["legs"][0]["arrival_time"]["value"]),
                          departure: journey["legs"][0]["start_address"],
                          arrival: journey["legs"][0]["end_address"],
                          steps: get_steps(journey["legs"][0]["steps"]),
                          departure_day: find_date(day_user, time_user, seconds_to_hm(journey["legs"][0]["departure_time"]["value"])),
                          arrival_day: find_date(day_user, time_user, seconds_to_hm(journey["legs"][0]["arrival_time"]["value"])),
                          price: rand(price..(price + 20))
                        }
    end
    journey_results
  end

  def self.get_steps(steps)
    steps_results = []
    steps.each do |step|
      unless step["travel_mode"] == "WALKING"
        steps_results << {
                          mode: mode(step),
                          icon: icone(mode(step)),
                          arrival_time: seconds_to_hm(step["transit_details"]["arrival_time"]["value"]),
                          arrival: step["transit_details"]["arrival_stop"]["name"],
                          departure_time: seconds_to_hm(step["transit_details"]["departure_time"]["value"]),
                          departure: step["transit_details"]["departure_stop"]["name"],
                          duration: step["duration"]["text"],
                          html_instructions: step["html_instructions"],
                          agency: step["transit_details"]["line"]["agencies"][0]["name"],
                          agency_url: step["transit_details"]["line"]["agencies"][0]["url"],
                          km: step["distance"]["value"] / 1000
                        }
        end
      end
    steps_results
  end

  # ---------------------- CARBON FOOTPRINT -------------------------------------

  # Calcul le C02 d'une étape en fonction du mode de transport et de la distance en km (en g C02 / passager)
  def self.carbon_emissions(mode, km)
    YAML.load_file('db/carbon.yml')[mode] * km
  end

  # Calcul le C02 total d'un voyage en plusieurs étapes (en g CO2 / passager)
  def self.total_carbon(steps)
    total_carbon = 0
    steps.each do |step|
      km = step["distance"]["value"] / 1000
      total_carbon += carbon_emissions(mode(step), km)
    end
    return total_carbon
  end

  # ---------------------- TRANSPORTATION MODE -------------------------------------

  # Obtenir le mode d'un step
  def self.mode(step)
    if step["travel_mode"] == "TRANSIT"
      mode = step["transit_details"]["line"]["vehicle"]["type"].downcase
    else
      mode = step["travel_mode"].downcase
    end
  end

  # Résumé des modes de transport d'un parcours (en icones)
  def self.modes_icones(steps)
    icones = []
    steps.each do |step|
      mode = mode(step)
      icone = icone(mode)
      icones << icone unless mode == "walking"
    end
    return icones
  end

  # Retourne un icone fontawsome par mode de transport
  def self.icone(mode)
    icones = YAML.load_file('db/icones.yml')
    return icones[mode]
  end

  # ---------------------- TIME AND DATE -------------------------------------

  # Calcul de l'heure et jour de départ pour l'url de l'api Google
  def self.departure_time(day, time)
    date_array = date_or_time_to_array(day)
    date_hour = Date.new(date_array[0], date_array[1], date_array[2]).to_datetime + Time.parse(time).seconds_since_midnight.seconds
    start_date = DateTime.parse("1970-01-01")
    elapsed_seconds = ((date_hour - start_date) * 24 * 60 * 60).to_i
    return elapsed_seconds
  end


  def self.seconds_to_hmin(seconds)
    Time.at(seconds).utc.strftime("%Hh %Mmin")
  end

  def self.seconds_to_hm(seconds)
    Time.at(seconds).utc.strftime("%H:%M")
  end

  def self.date_departure(date, time)
    date_array = date_or_time_to_array(date)
    time_array = date_or_time_to_array(time)
    time_array << 0 if time_array.size == 1
    user_date = DateTime.new(date_array[0], date_array[1], date_array[2], time_array[0], time_array[1])
    user_date
  end

  def self.find_date(date, time_a, time_b)
    user_date = date_departure(date, time_a)
    google_date = date_departure(date, time_b)
    google_date += 1 if google_date < user_date
    google_date.strftime("%d.%m.%Y")
  end

  def self.date_or_time_to_array(date)
    date.split("-").map! { |date| date.to_i }
  end
end
