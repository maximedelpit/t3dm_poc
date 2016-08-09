class Spec < ApplicationRecord

  TYPE = %w(Purpose Material HeatTreatment Surface Dimension QualityControl).freeze

  validates :type, presence: true
  validates :title, presence: true
end
