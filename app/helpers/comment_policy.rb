class CommentPolicy < ApplicationPolicy

  # Show chat comments
  def show?
    user.advisor? ||
    user.president? ||
    user.admin?
  end

  # Add comment to chat
  def create?
    user.advisor? ||
    user.president? ||
    user.admin?
  end
end
