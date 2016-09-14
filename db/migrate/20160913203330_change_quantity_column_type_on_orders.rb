class ChangeQuantityColumnTypeOnOrders < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :quantity, 'integer USING CAST(quantity AS integer)'
  end
end
