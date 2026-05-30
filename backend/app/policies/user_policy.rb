class UserPolicy < ApplicationPolicy
  def show?
    user.admin? || record.id == user.id
  end

  def update?
    show?
  end
end
