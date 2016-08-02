class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :topic, foreign_key: true
      t.string :github_id
      t.boolean :pinned
      t.references :user, foreign_key: true

      t.timestamps null: false
    end
  end
end
