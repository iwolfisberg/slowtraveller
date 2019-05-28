require 'nokogiri'
require 'open-uri'
require 'json'

class DestinationsController < ApplicationController
  def index
  end

  def show
    @destination = Destination.find(params[:id])

    # Au final, on aura besoin de ça ----------------->
    # url = "https://maps.googleapis.com/maps/api/directions/json?origin=Lausanne&destination=#{@destination.name}&mode=transit&key=GOOGLE_API_KEY"
    # route_serialized = open(url).read


    filepath = "paris_berlin.json"
    route_serialized = open(filepath).read

    route = JSON.parse(route_serialized)["routes"][0]

    @origin = route["legs"][0]["start_address"]
    @arrival = route["legs"][0]["end_address"]
    # @duration = route["legs"][0]["duration"]["text"]
    @distance = route["legs"][0]["distance"]["text"]
    @departure_time = route["legs"][0]["departure_time"]["text"]
    @arrival_time = route["legs"][0]["arrival_time"]["text"]

    @steps = route["legs"][0]["steps"]


    url_scraping = "https://www.rome2rio.com/fr/map/#{@origin.split(',').first}/#{@arrival.split(",").first}"
    html_file = open(url_scraping).read
    html_doc = Nokogiri::HTML(html_file)
    @price_estimation = []
    html_doc.search('.route__details > .route__price').each do |element|
      @price_estimation << element.text.strip
    end
  end
end
