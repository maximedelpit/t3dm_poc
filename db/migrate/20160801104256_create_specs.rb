class CreateSpecs < ActiveRecord::Migration[5.0]
  def change
    create_table :specs do |t|
      t.string :type
      t.string :title
      t.text :description
      t.boolean :standard
      t.references :project, foreign_key: true
      t.timestamps null: false
    end
  end
end
