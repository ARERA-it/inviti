class OpinionPolicy < ApplicationPolicy

  # Esprimere un parere
  def update?
    user.advisor?
  end
end
