class AddSeoFieldsToGradesPackingsPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :grades, :meta_title, :string
    add_column :grades, :meta_description, :text

    add_column :packings, :meta_title, :string
    add_column :packings, :meta_description, :text

    add_column :posts, :meta_title, :string
    add_column :posts, :meta_description, :text
  end
end
