class ContributionPolicy < ApplicationPolicy


  # Can show all contributions
  def index?
    role.can?('contribution', 'index')
  end


  # Add a contribute
  def create?(invitation)
    role.can?('contribution', 'create') ||
    invitation.appointed_users.include?(user)
  end


  # Destroy a contribute
  def destroy?
    role.can?('contribution', 'destroy') ||
    record.user==user
  end


  class Scope < Scope
    def resolve
      if role.can?('contribution', 'index')
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

end
