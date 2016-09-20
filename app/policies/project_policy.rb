class ProjectPolicy < ApplicationPolicy
  def create?
   user.category == 'client'
  end

  def show?
    record.users.include?(user)
  end

  def update?
    show?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
