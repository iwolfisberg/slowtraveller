class DeleteJourneyToFavorites < ActiveRecord::Migration[5.2]
  def change
    remove_column :favorites, :journey
  end
end
