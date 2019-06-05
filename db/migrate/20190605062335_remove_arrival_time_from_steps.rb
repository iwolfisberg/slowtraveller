class RemoveArrivalTimeFromSteps < ActiveRecord::Migration[5.2]
  def change
    remove_column :steps, :arrival_time, :string
  end
end
