class CreateProjectUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :project_users do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps null: false
    end
  end
end
