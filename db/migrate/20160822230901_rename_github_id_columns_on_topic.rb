class RenameGithubIdColumnsOnTopic < ActiveRecord::Migration[5.0]
  def change
    rename_column :topics, :github_id, :github_number
  end
end
