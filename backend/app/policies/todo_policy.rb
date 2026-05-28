class TodoPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.admin? || record.user_id == user.id
  end

  def create?
    user.present?
  end

  def update?
    user.admin? || record.user_id == user.id
  end

  def destroy?
    user.admin? || record.user_id == user.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.active
      else
        scope.active.where(user:)
      end
    end
  end
end
