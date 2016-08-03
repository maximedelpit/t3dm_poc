class Comment < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  has_many :mentions
  has_many :recipients, through: :mentions, class_name: 'User'

  validates :topic, :user presence: true
  validates :github_id, presence: true, uniqueness: true

  def author
    user
  end

end
