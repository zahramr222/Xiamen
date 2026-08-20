class CreateInquiries < ActiveRecord::Migration[8.1]
  def change
    create_table :inquiries do |t|
      t.string :full_name
      t.string :email
      t.string :phone
      t.string :company
      t.string :product
      t.string :packing
      t.string :country
      t.string :port_of_discharge
      t.text :details

      t.timestamps
    end
  end
end
