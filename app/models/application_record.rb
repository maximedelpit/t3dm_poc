class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def current_user
    Proc.new{ |controller, model| controller.current_user }
  end
end
