class ChangeGithubNumberTypeOnTopic < ActiveRecord::Migration[5.0]
  def change
    change_column :topics, :github_number, 'integer USING CAST(github_number AS integer)'

  end
end
