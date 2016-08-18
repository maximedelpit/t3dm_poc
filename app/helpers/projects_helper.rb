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

  def nested_trees(repo)
    repo.map do |data, sub_data|
      if data.type == 'tree'
        content_tag(
          :ul,
          render(partial: "projects/repo_tree", locals: { data: data, subdata: sub_data }) + content_tag(:ul, nested_trees(sub_data), :class => "nested_tree"),:class => "nested_tree")
      else
        render(partial: "projects/repo_tree", locals: { data: data, subdata: sub_data }) + content_tag(:ul, nested_trees(sub_data), :class => "nested_tree")
      end
    end.join.html_safe
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
