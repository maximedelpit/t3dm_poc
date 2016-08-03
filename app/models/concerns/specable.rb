module Specable
  extend ActiveSupport::Concern

  included do
      belongs_to :project
      validates :project, presence: true
      has_ancestry # TO DO: check if relevant here
  end
end
