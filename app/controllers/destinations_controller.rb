require 'open-uri'
require 'json'
require 'yaml'

class DestinationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params["/destinations"] != nil
      location = params["/destinations"]["location"]
      day = params["/destinations"]["departure_day"]
      time = params["/destinations"]["departure_time"]

      destinations_results = Destination.where.not(name: location.capitalize).order(score: :desc).near(location, 1500).take(10)
      destinations_array = []
      destinations_results.each do |destination|
        url_transit = "https://maps.googleapis.com/maps/api/directions/json?origin=#{location}&destination=#{destination.name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').downcase.to_s}&departure_time=#{departure_time(day, time)}&mode=transit&alternatives=true&key=#{ENV['GOOGLE_API_KEY']}"
        @routes_transit = parse_api(url_transit)

        results = { id: destination.id, name: destination.name, country: destination.country, photo_url: destination.photo_url, description: destination.description, journeys: get_journey(@routes_transit) } unless @routes_transit.keys[0] == "available_travel_modes"
        destinations_array << results unless results.nil?
      end
      @destinations_array = destinations_array.first(5)
    end
  end

  def show
    @chosen_destination = Destination.find(params[:id])
    @journey = params[:journey]
    @steps = @journey["steps"]
  end

  private

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
      if step["travel_mode"] == "TRANSIT"
        mode = step["transit_details"]["line"]["vehicle"]["type"].downcase
      else
        mode = step["travel_mode"].downcase
      end
    total_carbon += carbon_emissions(mode, km)
    end
    return total_carbon
  end

  # methode pour calculer heure et jour de départ pour l'url de l'api
  def departure_time(day, time)
    date_array = day.split("-").map! { |date| date.to_i }
    date_hour = Date.new(date_array[0], date_array[1], date_array[2]).to_datetime + Time.parse(time).seconds_since_midnight.seconds
    start_date = DateTime.parse("1970-01-01")
    elapsed_seconds = ((date_hour - start_date) * 24 * 60 * 60).to_i
    return elapsed_seconds
  end

  def parse_api(url)
    route_serialized = open(url).read
    route = JSON.parse(route_serialized)
    return route
  end

  def get_journey(routes_transit)
    journey_results = []
    routes_transit["routes"].each do |journey|
      journey_results << {
                          duration: journey["legs"][0]["duration"]["text"],
                          carbon: total_carbon(journey["legs"][0]["steps"]) / 1000,
                          connections: get_steps(journey["legs"][0]["steps"]).size,
                          departure_time: journey["legs"][0]["departure_time"]["text"],
                          arrival_time: journey["legs"][0]["arrival_time"]["text"],
                          departure: journey["legs"][0]["start_address"],
                          arrival: journey["legs"][0]["end_address"],
                          steps: get_steps(journey["legs"][0]["steps"])
                        }
    end
    journey_results
  end

  def get_steps(steps)
    steps_results = []
    steps.each do |step|
      unless step["travel_mode"] == "WALKING"
        steps_results << {
                          icon: step["transit_details"]["line"]["vehicle"]["icon"],
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
end
