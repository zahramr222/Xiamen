class CreateGradeTags < ActiveRecord::Migration[8.1]
  def change
    create_table :grade_tags do |t|
      t.references :grade, null: true, foreign_key: true
      t.references :tag, null: true, foreign_key: true

      t.timestamps
    end
  end
end
