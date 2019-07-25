class RequestOpinionPolicy < ApplicationPolicy

  # Can ask for an opinion (via e-mail)
  def create?
    user.president? ||
    user.admin?
  end
end
