class RemovePackingFromGrades < ActiveRecord::Migration[8.1]
  def change
    remove_reference :grades, :packing, null: false, foreign_key: true
  end
end
