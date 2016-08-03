class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :project

  has_many :comments

  validates :state, :category, :user, :project, presence: true
  validates :type, presence: true, inclusion: { in: %w(PullRequest Issue large) }
  validates :github_id, presence: true, uniqueness: true
end
