class RolePolicy < ApplicationPolicy
  def index?
    role.can?('role', 'index')
  end

  def show?
    role.can?('role', 'show')
  end

  def update?
    role.can?('role', 'update')
  end

  def duplicate?
    role.can?('role', 'create')
  end

  def destroy?
    role.can?('role', 'destroy')
  end
end
