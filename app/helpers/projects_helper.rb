module ProjectsHelper

  def define_active_filter
    def define_active
      if params[:filters] = 'feasibility'
        @all_active = 'active'
      elsif params[:filters] = 'Bid'
        @all_active = 'active'
      elsif params[:filters] = 'Production'
        @all_active = 'active'
      elsif params[:filters] = 'Past'
        @all_active = 'active'
      else
        @all_active = 'active'
      end
    end
  end
end
