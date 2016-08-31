class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :state
      t.string :due_date
      t.integer :price
      t.string :quantity
      t.string :integer

      t.timestamps
    end
  end
end
