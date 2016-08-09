class Project < ApplicationRecord
  module ExternalInput

    def self.next_thales_id
      # This will need to be plugged to ERP
      self.parent.last ? next_id = (self.parent.last.id + 1).to_s : next_id = '1'
      base = 'T3DM-'
      while next_id.size < 6
        next_id = '0' + next_id
      end
      return (base + next_id).gsub(' ','-')
    end

    def set_default_dimensions
      # TO DO =>  replace with set dimensions when stl upload
      self.length = BigDecimal.new(250)
      self.width = BigDecimal.new(250)
      self.height = BigDecimal.new(300)
      self.measurement_unit = 'mm'
      self.min_wall_thickness = BigDecimal.new(0.2, 3)
      self.min_hole_diameter = BigDecimal.new(0.3, 3)
      self.max_pipe_diameter = BigDecimal.new(0.7, 3)
      return self
    end
  end
end
