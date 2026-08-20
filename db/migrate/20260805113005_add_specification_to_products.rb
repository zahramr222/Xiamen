class AddSpecificationToProducts < ActiveRecord::Migration[8.1]
  def change
    add_reference :products, :specification, null: true, foreign_key: true
  end
end
