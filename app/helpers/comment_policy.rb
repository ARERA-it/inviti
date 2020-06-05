class CommentPolicy < ApplicationPolicy

  # Show chat comments
  def show?
    role.can?('comment', 'show')

    # user.advisor? ||
    # user.president? ||
    # user.admin?
  end

  # Add comment to chat
  def create?
    role.can?('comment', 'create')
    # user.advisor? ||
    # user.president? ||
    # user.admin?
  end
end
