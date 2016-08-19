class AddDueDateColumnToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :due_date, :date
  end
end
