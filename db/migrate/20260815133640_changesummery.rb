class Changesummery < ActiveRecord::Migration[8.1]
  def change
    change_column :posts, :summery, :text
  end
end
