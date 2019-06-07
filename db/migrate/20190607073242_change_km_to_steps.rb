class ChangeKmToSteps < ActiveRecord::Migration[5.2]
  def change
    rename_column :steps, :km_total, :km
  end
end
