class UserPolicy < ApplicationPolicy

  # only admin -> see ApplicationPolicy
  
  # def index?
  #   user.admin?
  # end
  #
  # def update?
  #   user.admin? or not record.published?
  # end
end
