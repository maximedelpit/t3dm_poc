class AddAncestryToSpec < ActiveRecord::Migration[5.0]
  def change
    add_column :specs, :ancestry, :string
    add_index :specs, :ancestry
  end
end
