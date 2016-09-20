class MeetingPolicy < ApplicationPolicy
  def create?
    binding.pry
    record.project_id ? record.attendees.map(&:user_id).include?(user.id) : true

  end

  def update?
    create?
  end

  class Scope < Scope
    def resolve
      user.meetings.to_come
    end
  end
end
