class CommentPolicy < ApplicationPolicy

  # Show chat comments
  def show?
    create? || role.can?('comment', 'show')
  end

  # Add comment to chat
  def create?
    role.can?('comment', 'create')
  end
end
