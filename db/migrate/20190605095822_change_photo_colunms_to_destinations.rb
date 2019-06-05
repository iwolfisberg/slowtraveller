class ChangePhotoColunmsToDestinations < ActiveRecord::Migration[5.2]
  def change
    add_column :destinations, :photo_url_small, :string
    rename_column :destinations, :photo_url, :photo_url_medium
  end
end
