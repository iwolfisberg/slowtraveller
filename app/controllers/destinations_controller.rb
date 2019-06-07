require 'open-uri'
require 'json'
require 'yaml'
require 'price_service'

class DestinationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :price]

  def index
    @user_destination_id = params[:user_destination_id]
    @user_location = params[:location_user]

    if params["/destinations"] != nil
      location = params["/destinations"]["location"]
      day = params["/destinations"]["departure_day"]
      time = define_departure_time(params["/destinations"]["departure_time"])
      @current_user = current_user
      @destinations_array = ApiRequestService.google_api_request(params["/destinations"][:user_destination_id], location, day, time, @current_user)

      respond_to do |format|
        format.js
      end
    end
  end

  def show
    @chosen_destination = Destination.find(params[:id])
    @journey = params[:journey]
    @steps = @journey["steps"]
    @plane_difference = carbon_equivalent(@journey["carbon"], "plane").to_i - @journey["carbon"].to_i
    @burger_equivalent = carbon_equivalent(@journey["carbon"], "burger").to_i
    @shower_equivalent = carbon_equivalent(@journey["carbon"], "shower").to_i
  end

  def price
    @prices = PriceService.calculate_price(params["journey"]["steps"])
    respond_to do |format|
      format.js
    end
  end

  # PRIVATE ===================================================================
  private

  # Calcul l'équivalence de l'emprunte carbone du trajet avec le nombre de km en avion, le nombre de burger et le nombre de douche
  def carbon_equivalent(carbon_amount, comparator)
    carbon_amount.to_i * 1000.fdiv(YAML.load_file('db/carbon.yml')[comparator])
  end

  def define_departure_time(time_choice)
    if time_choice == "Morning"
      time = "08:00"
    elsif time_choice == "Afternoon"
      time = "13:00"
    elsif time_choice == "Evening"
      time = "17:00"
    else
      time = "10:00"
    end
    time
  end
end
