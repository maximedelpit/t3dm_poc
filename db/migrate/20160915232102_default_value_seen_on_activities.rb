class DefaultValueSeenOnActivities < ActiveRecord::Migration[5.0]
  def change
    change_column :activities, :seen, :boolean, default: false
  end
end
