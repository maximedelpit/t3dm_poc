class Meeting < ApplicationRecord
  belongs_to :project
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees
  # validates :start_time, :end_time, :object, presence: true
  validate :check_date
  validate :check_time

  accepts_nested_attributes_for :attendees, allow_destroy: true, reject_if: :all_blank

  attr_accessor :date
  attr_accessor :time
  attr_accessor :duration
  attr_accessor :live

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

  def room_name
    "t3dm_poc_#{id}_#{object}_#{project_id}_#{start_time.to_i}"
  end
end
