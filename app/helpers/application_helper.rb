module ApplicationHelper
  require "base64"
  def formatted_date(date)
    date.nil? ? 'n/a' : date.strftime('%m/%d/%y')
  end

  def formatted_time(date)
    date.nil? ? 'n/a' : date.strftime('%m/%d/%y - %H:%M')
  end

  def send_gh_data(file)
    content_type = Mime[file[:extension].gsub('.','').to_sym]
    # content = Base64.decode64(file[:content])
    send_data file[:content], type: content_type, filename: file[:basename], :x_sendfile => true, disposition: 'attachment'
  end

  def generate_random_number(min, max)
    rand * (max-min) + min
  end

  def random_machine_usage
    usage = {}
    ProjectStateMachine.production[0..-3].each do |state|
      usage[state] = generate_random_number(0, 1)
    end
    return usage
  end

  def production_days(project)
    start = project.transitions.where(to_state: 'preparation').order(created_at: :asc).limit(1).first.created_at
    finish = project.transitions.where(to_state: 'payment').order(created_at: :asc).limit(1).first.created_at
    production_days = (finish - start) / 3600 / 24
    return (0...production_days.ceil).map {|val| "Day #{val}"}
  end
end
