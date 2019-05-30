class FavoritesController < ApplicationController
  def create
    destination = params["dest"].to_i
    Favorite.create!(
      user: current_user,
      destination_id: destination
    )
  end
end
