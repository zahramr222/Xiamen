class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :content
      t.string :slug
      t.references :grade, null: true, foreign_key: true

      t.timestamps
    end
  end
end
