class AppointeePolicy < ApplicationPolicy

  # aggiungere un partecipante

  def change?
    role.can?('appointee', 'change')
  end

  def create?
    change?
  end

  def view_comments?
  	user.id==record.user_id || role.can?('appointee', 'view_comments')
  end
end
