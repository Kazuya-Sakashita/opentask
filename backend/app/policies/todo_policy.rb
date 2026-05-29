class TodoPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.admin? || own_todo?
  end

  def create?
    user.present?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.active if user.admin?

      scope.active.where(user:)
    end
  end

  private

  def own_todo?
    record.user_id == user.id
  end
end
