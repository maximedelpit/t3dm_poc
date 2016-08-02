class CreateMentions < ActiveRecord::Migration[5.0]
  def change
    create_table :mentions do |t|
      t.references :user, foreign_key: true
      t.references :comment, foreign_key: true

      t.timestamps null: false
    end
  end
end
