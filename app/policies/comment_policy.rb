class CommentPolicy < ApplicationPolicy
  def create?
    record.topic.project.users.include?(user)
  end

  def update?
    record.user == user
  end

  def download?
    create?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
