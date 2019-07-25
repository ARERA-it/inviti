class UserPolicy < ApplicationPolicy

  # only admin -> see ApplicationPolicy

  # def index?
  #   user.admin?
  # end
  #
  def show?
    user.admin? or user.id==record.id
  end
  def edit?
    user.admin? or user.id==record.id
  end
  def update?
    user.admin? or user.id==record.id
  end
  def change_role?
    user.admin?
  end


  def permitted_attributes
    if user.admin?
      [:username, :display_name, :initials, :job_title, :role, :title, :appointeeable, :advisor_group, :gender]
    else
      [:display_name, :initials, :job_title, :title, :gender]
    end
  end

  def topbar_full_menu?
    user.admin?
  end
end
