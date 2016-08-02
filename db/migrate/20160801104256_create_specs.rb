class CreateSpecs < ActiveRecord::Migration[5.0]
  def change
    create_table :specs do |t|
      t.string :category
      t.string :name
      t.text :description
      t.boolean :custom
      t.references :project, foreign_key: true
      t.text :parts_functionality

      t.timestamps null: false
    end
  end
end
