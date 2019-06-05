class AddArrivalTimeToSteps < ActiveRecord::Migration[5.2]
  def change
    add_column :steps, :arrival_time, :string
  end
end
