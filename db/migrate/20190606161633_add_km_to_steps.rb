class AddKmToSteps < ActiveRecord::Migration[5.2]
  def change
    add_column :steps, :km_total, :integer
  end
end
