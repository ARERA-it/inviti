class RequestOpinionPolicy < ApplicationPolicy

  # Richiedere un parere
  def create?
    user.president? || user.admin?
  end
end
