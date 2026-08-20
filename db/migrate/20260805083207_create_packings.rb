class CreatePackings < ActiveRecord::Migration[8.0]
  def change
    create_table :packings do |t|
      t.string :name
      t.references :specification, null: true, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
