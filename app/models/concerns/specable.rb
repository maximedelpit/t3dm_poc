module Specable
  extend ActiveSupport::Concern

  included do
      belongs_to :project
      has_ancestry # TO DO: check if relevant here
      # validate :check_if_standard, on: [:create, :update]

      def check_if_standard
        if title
          title == 'other' ? false : true
        end
      end
  end
end
