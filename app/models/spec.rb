class Spec < ApplicationRecord

  TYPE = %w(Purpose Material HeatTreatment Surface Dimension QualityControl).freeze

  validates :type, presence: true
  validates :title, presence: true

  def full_spec_description
    if title =='other' && description
      return "#{type}: #{title} - #{decription}"
    else
      return "#{type}: #{title}"
    end
  end
end
