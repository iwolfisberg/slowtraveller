# require 'open-uri'
require 'json'

class DestinationsController < ApplicationController
  def index
  end

  def show
    @destination = Destination.find(params[:id])
    # url = "https://maps.googleapis.com/maps/api/directions/json?origin=Lausanne&destination=#{@destination.name}&mode=transit&key=GOOGLE_API_KEY"
    # route_serialized = open(url).read


    filepath = "lausanne_paris.json"
    route_serialized = open(filepath).read
    route = JSON.parse(route_serialized)["routes"][0]
    @origin = route["legs"][0]["start_address"]
    @arrival = route["legs"][0]["end_address"]
    @duration = route["legs"][0]["duration"]["text"]
    @distance = route["legs"][0]["distance"]["text"]

    # counter = 0
    @steps = route["legs"][0]["steps"]
  end
end
