class GroupPolicy < ApplicationPolicy

  def index?
    role.can?('group', 'index')
  end

  def show?
    role.can?('group', 'show')
  end

  def create?
    role.can?('group', 'create')
  end

  def update?
    role.can?('group', 'update')
  end

  def destroy?
    role.can?('group', 'destroy')
  end

end
