class ChangeDueDateOnOrders < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :due_date, 'date USING CAST(due_date AS date)'

  end
end
