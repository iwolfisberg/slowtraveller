class CreateDestinations < ActiveRecord::Migration[5.2]
  def change
    create_table :destinations do |t|
      t.string :name
      t.string :description
      t.string :country
      t.string :photo_url

      t.timestamps
    end
  end
end
