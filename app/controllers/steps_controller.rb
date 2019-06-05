class StepsController < ApplicationController
  def create
    info_step = params["info_step"]
    Step.create!(
      user: current_user,
      destination_id: info_step[:id],
      carbon: info_step[:journey][:carbon],
      departure: info_step[:journey][:departure],
      arrival: info_step[:journey][:arrival],
      arrival_time: info_step[:journey][:arrival_time]
    )
    redirect_to traveldiary_steps_path
  end

  def traveldiary
    @steps = Step.where(user: current_user)
    @carbon_total = 0
    @steps.each { |step| @carbon_total += step[:carbon] }
  end
end
