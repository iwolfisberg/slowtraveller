class FavoritesController < ApplicationController
  def create
    @destination_id = params["dest"].to_i
    @favorite = Favorite.create!(
      user: current_user,
      destination_id: @destination_id
    )
    respond_to do |format|
      format.js
    end
  end

  def list
    @favorites = Favorite.where(user: current_user)
  end

  def destroy
    favorite = Favorite.find(params[:id])
    @destination = favorite.destination
    favorite.destroy
    respond_to do |format|
      format.js
    end
  end
end
