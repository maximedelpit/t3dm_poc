class TopicPolicy < ApplicationPolicy
  def index?
    user.projects.include?(record.project)
  end

  def show?
    index?
  end

  def create?
    index?
  end

  def update?
    index?
  end

  class Scope < Scope
    def resolve
      record.topics
    end
  end
end
