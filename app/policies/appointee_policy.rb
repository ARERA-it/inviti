class AppointeePolicy < ApplicationPolicy

  # aggiungere un partecipante

  def change?
    role.can?('appointee', 'change')
  end

  def create?
    change?
  end

  def edit_form?
    change?
  end

  # there is another policy used inside invitation_policy
  # role.can?('appointee', 'change_note')

  def view_comments?
  	user.id==record.user_id || role.can?('appointee', 'view_comments')
  end
end
