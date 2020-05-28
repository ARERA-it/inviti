class UserPolicy < ApplicationPolicy

  # only admin -> see ApplicationPolicy

  def index?
    role.can?('user', 'index')
  end

  def show?
    role.can?('user', 'show') || user.id==record.id
  end

  def create?
    role.can?('user', 'create')
  end

  def new?
    create?
  end

  def update?
    role.can?('user', 'update')
  end

  def edit?
    update?
  end

  def destroy?
    role.can?('user', 'destroy')
  end

  def update_sensitive_attributes?
    role.can?('user', 'update_sensitive_attributes')
  end


  def permitted_attributes
    if role.can?('user', 'update_sensitive_attributes')
      [:display_name, :initials, :job_title, :title, :gender, :username, :role_id, :title, :appointeeable, :advisor_group]
    else
      [:display_name, :initials, :job_title, :title, :gender]
    end
  end

end
