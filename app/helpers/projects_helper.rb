module ProjectsHelper
  def breadcrumb_generated_items
    if project_breadcrumb_conditions
      breadcrumb = {
        cycle: @project.cycle,
        phasis: @project.state_machine.phasis,
        state: @project.state_machine.current_state
      }
      return breadcrumb
    else
    end
  end

  private
  def project_breadcrumb_conditions
    %w(projects comments topics).include?(params[:controller]) && %w(show edit).include?(params[:action])
  end

  def format_value(entry, value)
    value ||= 'n/a'
    if entry.nil?
      return value
    else
      return "#{entry.capitalize}: #{value}"
    end
  end
end
