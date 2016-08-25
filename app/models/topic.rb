class Topic < ApplicationRecord
  # TO DO => drop category table?
  belongs_to :user
  belongs_to :project

  has_many :comments

  validates :state, :user, :project, presence: true
  validates :type, presence: true, inclusion: { in: %w(PullRequest Issue) }
  validates :github_number, presence: true, uniqueness: true, on: :update

  attr_accessor :content, :title
end
