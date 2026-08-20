class CreateGrades < ActiveRecord::Migration[8.1]
  def change
    create_table :grades do |t|
      t.string :name
      t.text :content
      t.references :specification, null: true, foreign_key: true
      t.references :packing, null: true, foreign_key: true

      t.timestamps
    end
  end
end
