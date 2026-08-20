class AddSummeryToPost < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :summery, :string
  end
end
