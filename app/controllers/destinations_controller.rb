require 'open-uri'
require 'json'
require 'yaml'

class DestinationsController < ApplicationController
  def index
    if params["/destinations"] != nil
      @location = params["/destinations"]["location"]
      @day = params["/destinations"]["departure_day"]
      @time = params["/destinations"]["departure_time"]
      @destinations = Destination.near(@location, 1500).last(5)
    end
  end

  def show
    @destination = Destination.find(params[:id])

    origin = params[:location]
    @departure_day_user = params[:day]
    date_array = @departure_day_user.split("-").map! { |date| date.to_i }
    departure_time_user = params[:time]
    date_hour = Date.new(date_array[0], date_array[1], date_array[2]).to_datetime + Time.parse(departure_time_user).seconds_since_midnight.seconds
    start_date = DateTime.parse("1970-01-01")
    elapsed_seconds = ((date_hour - start_date) * 24 * 60 * 60).to_i

    url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{origin}&destination=#{@destination.name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').downcase.to_s}&departure_time=#{elapsed_seconds}&mode=transit&key=#{ENV['GOOGLE_API_KEY']}"
    route_serialized = open(url).read
    @route = JSON.parse(route_serialized)

    if @route.keys[0] == "available_travel_modes"
      driving_url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{origin}&destination=#{@destination.name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').downcase.to_s}&mode=driving&key=#{ENV['GOOGLE_API_KEY']}"
      driving_route_serialized = open(driving_url).read
      driving_route = JSON.parse(driving_route_serialized)["routes"][0]["legs"][0]

      @distance_driving = driving_route["distance"]["text"]
      @duration_driving = driving_route["duration"]["text"]
      @departure_driving = driving_route["start_address"]
      @arrival_driving = driving_route["end_address"]
      km = driving_route["distance"]["value"] / 1000
      @carbon = carbon_emissions("driving", km)
    else
      @duration = @route["routes"][0]["legs"][0]["duration"]["text"]
      @departure = @route["routes"][0]["legs"][0]["start_address"]
      @departure_time = @route["routes"][0]["legs"][0]["departure_time"]["text"]
      @arrival = @route["routes"][0]["legs"][0]["end_address"]
      @arrival_time = @route["routes"][0]["legs"][0]["arrival_time"]["text"]
      @steps = @route["routes"][0]["legs"][0]["steps"]
      @carbon = total_carbon(@steps) / 1000
    end
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
end

