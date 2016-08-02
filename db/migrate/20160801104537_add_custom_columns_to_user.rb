class AddCustomColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :category, :string
    add_column :users, :entity, :string
  end
end
