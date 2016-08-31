class Meeting < ApplicationRecord
  belongs_to :project
  # validates :start_time, :end_time, :object, presence: true
  validate :check_date
  validate :check_time

  attr_accessor :date
  attr_accessor :time

  def check_date
    if self.date.empty?
      self.errors.details[:date] = [{:error=>:blank}]
      self.errors.messages[:date] = ["can't be blank"]
      return false
    else
      return true
    end
  end

  def check_time
    if self.time.empty?
      self.errors.details[:time] = [{:error=>:blank}]
      self.errors.messages[:time] = ["can't be blank"]
      return false
    else
      return true
    end
  end
end
