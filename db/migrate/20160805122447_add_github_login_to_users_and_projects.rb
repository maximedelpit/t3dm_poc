class AddGithubLoginToUsersAndProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :github_login, :string
    add_column :projects, :github_owner, :string
  end
end
