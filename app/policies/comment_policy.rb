class CommentPolicy < ApplicationPolicy

  # Esprimere un parere
  def create?
    user.advisor? || user.president? || user.admin?
  end
end
