class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.string :type
      t.string :github_id
      t.string :state
      t.string :category
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.string :project_state

      t.timestamps null: false
    end
  end
end
