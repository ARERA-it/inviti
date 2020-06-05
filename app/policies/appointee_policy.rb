class AppointeePolicy < ApplicationPolicy

  # aggiungere un partecipante

  def change?
    # user.president? || user.admin?
    role.can?('appointee', 'change')
  end

  def create?
    role.can?('appointee', 'create')
    # change?
  end
end
