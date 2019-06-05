class ApiRequest
  def index
    @user_destination_id = params[:user_destination_id]

    if params["/destinations"] != nil
      location = params["/destinations"]["location"]
      day = params["/destinations"]["departure_day"]
      time = params["/destinations"]["departure_time"]
      @user_destination_id = params["/destinations"][:user_destination_id]

      if @user_destination_id != ""
        destination_user_choice = Destination.find(@user_destination_id.to_i)
        array = []
        array << parse_api(destination_user_choice, location, day, time) unless parse_api(destination_user_choice, location, day, time).nil?
        @destinations_array = array
      else
        destinations_results = Destination.where.not(name: location.capitalize).order(score: :desc).near(location, 800).take(20)
        array = []
        destinations_results.each do |destination|
          array << parse_api(destination, location, day, time) unless parse_api(destination, location, day, time).nil?
        end
        @destinations_array = array.take(5)
      end
    end
  end

  def parse_api(destination, location, day, time)
    results_array = []
    url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{location}&destination=#{destination.name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').downcase.to_s}&departure_time=#{departure_time(day, time)}&mode=transit&alternatives=true&key=#{ENV['GOOGLE_API_KEY']}"
    routes = JSON.parse(open(url).read)
    results = { id: destination.id, name: destination.name, country: destination.country, photo_url: destination.photo_url, description: destination.description, journeys: get_journey(routes, day, time) } unless routes.keys[0] == "available_travel_modes"
    results
  end










  # Calcul l'équivalence de l'emprunte carbone du trajet avec le nombre de km en avion, le nombre de burger et le nombre de douche
  def carbon_equivalent(carbon_amount, comparator)
    carbon_amount.to_i * 1000.fdiv(YAML.load_file('db/carbon.yml')[comparator])
  end

  # Calcul le C02 d'une étape en fonction du mode de transport et de la distance en km (en g C02 / passager)
  def carbon_emissions(mode, km)
    carbon_factors = YAML.load_file('db/carbon.yml')
    return carbon_factors[mode] * km
  end

  # Calcul le C02 total d'un voyage en plusieurs étapes (en g CO2 / passager)
  def total_carbon(steps)
    total_carbon = 0
    steps.each do |step|
      km = step["distance"]["value"] / 1000
      mode = mode(step)
      total_carbon += carbon_emissions(mode, km)
    end
    return total_carbon
  end

  # Obtenir le mode d'un step
  def mode(step)
    if step["travel_mode"] == "TRANSIT"
      mode = step["transit_details"]["line"]["vehicle"]["type"].downcase
    else
      mode = step["travel_mode"].downcase
    end
  end

  # Résumé des modes de transport d'un parcours (en icones)
  def modes_icones(steps)
    icones = []
    steps.each do |step|
      mode = mode(step)
      icone = icone(mode)
      icones << icone unless mode == "walking"
    end
    return icones
  end

  # Retourne un icone fontawsome par mode de transport
  def icone(mode)
    icones = YAML.load_file('db/icones.yml')
    return icones[mode]
  end

  # Calcul de l'heure et jour de départ pour l'url de l'api Google
  def departure_time(day, time)
    date_array = day.split("-").map! { |date| date.to_i }
    date_hour = Date.new(date_array[0], date_array[1], date_array[2]).to_datetime + Time.parse(time).seconds_since_midnight.seconds
    start_date = DateTime.parse("1970-01-01")
    elapsed_seconds = ((date_hour - start_date) * 24 * 60 * 60).to_i
    return elapsed_seconds
  end


  def get_journey(routes_transit, day_user, time_user)
    journey_results = []
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
                          departure_day: find_google_date(day_user, time_user, seconds_to_hm(journey["legs"][0]["departure_time"]["value"])),
                          arrival_day: find_google_date(day_user, time_user, seconds_to_hm(journey["legs"][0]["arrival_time"]["value"]))
                        }
    end
    journey_results
  end

  def get_steps(steps)
    steps_results = []
    steps.each do |step|
      unless step["travel_mode"] == "WALKING"
        steps_results << {
                          mode: mode(step),
                          icon: icone(mode(step)),
                          arrival_time: step["transit_details"]["arrival_time"]["text"],
                          arrival: step["transit_details"]["arrival_stop"]["name"],
                          departure_time: step["transit_details"]["departure_time"]["text"],
                          departure: step["transit_details"]["departure_stop"]["name"],
                          duration: step["duration"]["text"],
                          html_instructions: step["html_instructions"],
                          agency: step["transit_details"]["line"]["agencies"][0]["name"],
                          agency_url: step["transit_details"]["line"]["agencies"][0]["url"]
                        }
        end
      end
    steps_results
  end

  def seconds_to_hmin(seconds)
    Time.at(seconds).utc.strftime("%Hh %Mmin")
  end

  def seconds_to_hm(seconds)
    Time.at(seconds).utc.strftime("%H:%M")
  end

  def date_departure(date, time)
    date_array = date.split("-").map! { |date| date.to_i } #donne la date sous forme d'array d'integer
    time_array = time.split("-").map! { |time| time.to_i } #idem pour heure
    time_array << 0 if time_array.size == 1
    user_date = DateTime.new(date_array[0], date_array[1], date_array[2], time_array[0], time_array[1]) #donne la date sous format DateTime: 2019-06-22T22:22:00+00:00
    user_date
  end
end
