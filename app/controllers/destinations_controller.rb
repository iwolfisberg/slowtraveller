class DestinationsController < ApplicationController
  def index
  end

  def show
    @destination = Destination.find(params[:id])
  end
end
