class OpinionPolicy < ApplicationPolicy

  # Esprimere un parere
  def update?
    user.advisor? || user.admin?
  end
end
