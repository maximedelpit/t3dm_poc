module ApplicationHelper
  def formatted_date(date)
    date.nil? ? 'n/a' : date.strftime('%m/%d/%y')
  end
end
