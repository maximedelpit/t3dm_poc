class CreateOrderLines < ActiveRecord::Migration[5.0]
  def change
    create_table :order_lines do |t|
      t.references :project, foreign_key: true
      t.references :order, foreign_key: true
      t.integer :unit_price
      t.integer :duration
      t.string :description

      t.timestamps
    end
  end
end
