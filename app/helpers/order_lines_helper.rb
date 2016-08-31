module OrderLinesHelper
  def generate_random_due_date(due_date)
    return 0 if due_date
    return Random.new().rand(1..90)
  end
end
