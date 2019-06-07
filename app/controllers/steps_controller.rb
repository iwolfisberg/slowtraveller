require 'yaml'

class StepsController < ApplicationController
  def create
    info_step = params["info_step"]
    km = 0
    info_step[:journey][:steps].each { |step| km += step[:km].to_i }
    @step = Step.create!(
      user: current_user,
      destination_id: info_step[:id],
      description: Destination.find(info_step[:id]).description,
      carbon: info_step[:journey][:carbon],
      departure: info_step[:journey][:departure],
      arrival: info_step[:journey][:arrival],
      arrival_day: info_step[:journey][:arrival_day],
      km: km
    )
    redirect_to traveldiary_steps_path
  end

  def traveldiary
    @steps = Step.where(user: current_user)
    @carbon_total = 0
    @steps.each { |step| @carbon_total += step[:carbon] }
    @km_total = 0
    @steps.each { |step| @km_total += step[:km] }
    @carbon_flight = carbon_emissions("plane", @km_total)
    raise
    @first_departure = @steps.first["departure"].split(",")[0] if @steps.size.positive?
    @location_user = Destination.find(@steps.last.destination_id).name if @steps.size.positive?
  end

  def edit
    @step = Step.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @step = Step.find(params[:id])
    @description = params[:step]["description"]
    @step.description = params[:step][:description]
    @step.save

    respond_to do |format|
      format.js
    end
  end
end

private

# Calcul le C02 en fonction du mode de transport et de la distance en km (en g C02 / passager)
def carbon_emissions(mode, km)
  YAML.load_file('db/carbon.yml')[mode] * km
end
