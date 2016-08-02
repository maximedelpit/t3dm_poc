class Project < ApplicationRecord

  has_many :project_users
  has_many :specs
  has_many :topics

  validates :title, :client, :thales_key, :state, :cycle, presence: true
  validates :repo_id, uniqueness: true, on: :update
  validate :specs_presence

  def specs_presence
    true
  end
end
