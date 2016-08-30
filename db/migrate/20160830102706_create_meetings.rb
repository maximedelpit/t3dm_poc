class CreateMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :meetings do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :object
      t.string :state
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
