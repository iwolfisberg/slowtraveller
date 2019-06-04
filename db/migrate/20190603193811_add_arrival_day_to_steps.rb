class AddArrivalDayToSteps < ActiveRecord::Migration[5.2]
  def change
    add_column :steps, :arrival_day, :string
  end
end
