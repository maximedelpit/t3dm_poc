class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :part_functionality
      t.text :notes
      t.string :measurement_unit
      t.decimal :length
      t.decimal :width
      t.decimal :height
      t.decimal :min_wall_thickness
      t.decimal :min_hole_diameter
      t.decimal :max_pipe_diameter
      t.boolean :impossible_details
      t.boolean :trapped_volumes
      t.string :repo_id
      t.string :thales_key
      t.string :client
      t.string :state
      t.string :cycle

      t.timestamps null: false
    end
  end
end
