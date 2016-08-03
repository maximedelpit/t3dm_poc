class Mention < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :user:, :comment, presence: true
end
