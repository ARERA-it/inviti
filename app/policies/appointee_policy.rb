class AppointeePolicy < ApplicationPolicy

  # aggiungere un partecipante

  def change?
    user.president? || user.admin?
  end

  def create?
    change?
  end
end
