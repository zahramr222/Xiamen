class FixGradeSpecificationRelation < ActiveRecord::Migration[7.0]
  def change
    # 1. Remove specification_id from grades
    remove_column :grades, :specification_id, :integer
    
    # 2. Add grade_id to specifications
    add_column :specifications, :grade_id, :integer
    
  
  end
end