class CreateGradePackings < ActiveRecord::Migration[8.1]
  def change
    create_table :grade_packings do |t|
      t.references :grade, null: true, foreign_key: true
      t.references :packing, null: true, foreign_key: true

      t.timestamps
    end
  end
end
