class FavoritesController < ApplicationController
  def create
    destination = params["dest"]
    Favorite.create!(
      user: current_user,
      destination_id: destination,
      redirect_to: list_favorites_path
    )
  end

  def list
    @favorites = Favorite.where(user: current_user)
  end
end
