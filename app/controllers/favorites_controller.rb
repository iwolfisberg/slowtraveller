class FavoritesController < ApplicationController
  def create
    destination = params["dest"].to_i
    Favorite.create!(
      user: current_user,
      destination_id: destination
    )
  end

  def list
    @favorites = Favorite.where(user: current_user)
  end

  def destroy
    destination = params["dest"].to_i
    favorite = Favorite.where(user: current_user).where(destination: destination[:id])
    favorite.delete
  end
end
