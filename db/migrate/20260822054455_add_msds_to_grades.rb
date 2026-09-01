class AddMsdsToGrades < ActiveRecord::Migration[7.0]
  def change
    add_column :grades, :msds, :string
  end
end