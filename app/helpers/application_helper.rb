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
end
