require 'open-uri'
require 'json'

class DestinationsController < ApplicationController
  def index
    if params["/destinations"].blank? || params["/destinations"]["location"].blank?
      @destinations = Destination.all
    else
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
    else
      @duration = @route["routes"][0]["legs"][0]["duration"]["text"]
      @departure = @route["routes"][0]["legs"][0]["start_address"]
      @departure_time = @route["routes"][0]["legs"][0]["departure_time"]["text"]
      @arrival = @route["routes"][0]["legs"][0]["end_address"]
      @arrival_time = @route["routes"][0]["legs"][0]["arrival_time"]["text"]
      @steps = @route["routes"][0]["legs"][0]["steps"]
    end
  end
end
