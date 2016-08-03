class Spec < ApplicationRecord

  TYPE = %w(Purpose Material HeatTreatment Surface Dimension QualityControl)

  validates :type, presence: true, inclusion: { in: %w(Purpose HeatTreatment large) }
  validates :title, :standard, presence: true
end
