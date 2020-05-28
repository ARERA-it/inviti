class UserInteractionPolicy < ApplicationPolicy

  def index?
    role.can?('user_interaction', 'index')
  end
end
