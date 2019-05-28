class DestinationsController < ApplicationController
  def index
    if params["/destinations"].blank? || params["/destinations"]["location"].blank?
      @destinations = Destination.all
    else
      location = params["/destinations"]["location"]
      @destinations = Destination.near(location, 1000)
    end
  end

  def show
  end
end
