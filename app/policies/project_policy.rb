class ProjectPolicy < ApplicationPolicy

  def update?
    role.can?('project', 'update')
  end

  def edit?
    update?
  end

end
