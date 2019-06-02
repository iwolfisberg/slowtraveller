class AddColumnsToSteps < ActiveRecord::Migration[5.2]
  def change
    add_column :steps, :carbon, :integer
    add_column :steps, :departure, :string
    add_column :steps, :arrival, :string
  end
end
