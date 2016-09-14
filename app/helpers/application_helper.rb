module ApplicationHelper
  def formatted_date(date)
    date.nil? ? 'n/a' : date.strftime('%m/%d/%y')
  end

  def formatted_time(date)
    date.nil? ? 'n/a' : date.strftime('%m/%d/%y - %H:%M')
  end
end
