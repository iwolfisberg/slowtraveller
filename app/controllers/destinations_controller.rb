require 'open-uri'
require 'json'
require 'yaml'

class DestinationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @user_destination_id = params[:user_destination_id]

    if params["/destinations"] != nil
      location = params["/destinations"]["location"]
      day = params["/destinations"]["departure_day"]
      time = params["/destinations"]["departure_time"]
      @user_destination_id = params["/destinations"][:user_destination_id]

      @destinations_array = ApiRequest.google_api_request(@user_destination_id, location, day, time)
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

  private

  # Calcul l'équivalence de l'emprunte carbone du trajet avec le nombre de km en avion, le nombre de burger et le nombre de douche
  def carbon_equivalent(carbon_amount, comparator)
    carbon_amount.to_i * 1000.fdiv(YAML.load_file('db/carbon.yml')[comparator])
  end
end
