class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :repo_id
      t.string :thales_key
      t.string :client
      t.string :state
      t.string :cycle

      t.timestamps null: false
    end
  end
end
