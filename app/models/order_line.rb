class OrderLine < ApplicationRecord
  belongs_to :project
  belongs_to :order
end
