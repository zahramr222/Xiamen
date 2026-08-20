class CreateSpecifications < ActiveRecord::Migration[8.1]
  def change
    create_table :specifications do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
