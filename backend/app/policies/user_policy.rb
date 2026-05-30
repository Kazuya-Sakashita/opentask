class UserPolicy < ApplicationPolicy
  def show?
    user.admin? || record.id == user.id
  end

  def update?
    show?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user.admin?

      scope.where(id: user.id)
    end
  end
end
