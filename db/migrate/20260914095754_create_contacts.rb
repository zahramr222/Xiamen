class CreateContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :contacts do |t|
      t.string :full_name
      t.string :phone
      t.text :message

      t.timestamps
    end
  end
end
