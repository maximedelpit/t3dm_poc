class Order < ApplicationRecord
  has_many :order_lines, dependent: :destroy
  accepts_nested_attributes_for :order_lines, allow_destroy: true, reject_if: :all_blank

  attr_accessor :data_package

  def unit_price
    order_lines.sum("unit_price * duration")
  end

  def total
    unit_price.to_i * quantity.to_i
  end
end
