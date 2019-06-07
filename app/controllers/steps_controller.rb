class StepsController < ApplicationController
  def create
    info_step = params["info_step"]
    @step = Step.create!(
      user: current_user,
      destination_id: info_step[:id],
      description: Destination.find(info_step[:id]).description,
      carbon: info_step[:journey][:carbon],
      departure: info_step[:journey][:departure],
      arrival: info_step[:journey][:arrival],
      arrival_day: info_step[:journey][:arrival_day]
    )
    redirect_to traveldiary_steps_path
  end

  def traveldiary
    @steps = Step.where(user: current_user)
    @carbon_total = 0
    @steps.each { |step| @carbon_total += step[:carbon] }
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
    @description = @step.description_extract
    @step.description = params[:step][:description]
    @step.save

    respond_to do |format|
      format.js
    end
  end
end
