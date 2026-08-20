class ChangeGradeToProductRelation < ActiveRecord::Migration[7.0]
  def change
    # 1. Remove grade_id from products
    remove_column :products, :grade_id, :integer
    
    # 2. Add product_id to grades
    add_column :grades, :product_id, :integer
    
  end
end
