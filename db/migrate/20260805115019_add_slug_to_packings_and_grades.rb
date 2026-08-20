class AddSlugToPackingsAndGrades < ActiveRecord::Migration[8.0]
  def change
    add_column :packings, :slug, :string
    add_column :grades, :slug, :string
  end
end