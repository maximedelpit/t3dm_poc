class Order < ApplicationRecord
  has_many :order_lines, dependent: :destroy

  accepts_nested_attributes_for :order_lines, allow_destroy: true, reject_if: :all_blank
end
