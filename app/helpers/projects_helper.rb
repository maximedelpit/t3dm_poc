module ProjectsHelper
  def breadcrumb_generated_items
    breadcrumb = {}
    if project_breadcrumb_conditions
      breadcrumb[:cycle] = @project.cycle.capitalize
      breadcrumb[:state] = @project.state_machine.current_state.gsub('_', ' ').capitalize
    else
    end
    return breadcrumb
  end

  # def nested_trees(repo)
  #   repo.map do |data, sub_data|
  #     render(partial: "projects/repo_tree", locals: { data: data, subdata: sub_data }) + content_tag(:ul, nested_trees(sub_data), :class => "nested_tree")
  #   end.join.html_safe
  # end

  def nested_trees(repo)
    repo.map do |data, sub_data|
      render layout:"projects/repo_tree", locals: { data: data } do
        content_tag(:ul, nested_trees(sub_data)) if sub_data != {}
      end
    end.join.html_safe
  end

  private
  def project_breadcrumb_conditions
    if %w(projects comments topics).include?(params[:controller])
      %w(show edit).include?(params[:action])
    elsif params[:controller] == 'project_states'
      params[:action] == 'update'
    end
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
