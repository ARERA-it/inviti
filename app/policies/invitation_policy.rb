class InvitationPolicy < ApplicationPolicy

  def index?
    role.can?('invitation', 'index')
  end


  # user roles: :president, :advisor, :commissary, :secretary, :viewer, :admin
  def show?
    role.can?('invitation', 'show')
  end

  # Vedere i pareri
  # la card dei pareri ha dentro molte cose diverse
  # uno può vedere il riquadro delle opinioni se può vedere almeno uno dei
  # suoi contenuti
  # TODO: viene ancora usato!!!
  def view_opinion?
    # role.can?('invitation', 'view_opinion')
    false
  end

  # express_opinion? MOVED TO opinion/update
  # def express_opinion?
    # role.can?('invitation', 'express_opinion')
    # record.users_who_was_asked_for_an_opinion.include?(user.id)

    # user.admin? ||
    # user.advisor? ||
    # record.users_who_was_asked_for_an_opinion.include?(user)
  # end

  def audits?
    role.can?('invitation', 'audits')
  end

  # Vedere il pannello della persona incaricata
  def view_appointee?
    role.can?('invitation', 'view_appointee')
  end

  def update_delegation_notes?
    role.can?('appointee', 'change_note') # invitation#delegation_notes
  end


  # Vedere il pannello dei contributi
  def view_contributions?
    true
    # role.can?('invitation', 'view_contributions')
  end

  # Vedere il pannello delle info generali
  def view_general_info?
    show?
  end

  # Vedere il pannello della email
  def view_email_info?
    role.can?('invitation', 'view_email_info')
  end

  def show_audit?
    show? # TODO: davvero?
  end

  # participate or not?
  def update_participation?
    role.can?('invitation', 'update_participation')
  end

  # def cancel_participation?
  #   update_participation?
  # end

  def update_general_info?
    role.can?('invitation', 'update_general_info')
  end


  def update? # Le info generali
    update_general_info?
  end

  def usual_and_particular
    user.admin? ||
    user.president? ||
    user.advisor? ||
    user.secretary? ||
    record.users_who_was_asked_for_an_opinion.include?(user)
  end

  def destroy?
    role.can?('invitation', 'destroy')
    # return true  if user.admin?
    # return true  if user.secretary? && (record.no_info? || record.info?)
  end

  def download_ics?
    role.can?('invitation', 'download_ical')
  end




  def proposal_to_all_board_members?
    user.admin? || user.president?
  end

  # Esprimere un parere  ->  v. opinion_policy
  # Aggiungere un commento (dopo il parere)  ->  v. comment_policy





  class Scope < Scope
    def resolve
      if role.can?('invitation', 'see_all')
        scope.all
      elsif role.can?('invitation', 'only_see_his_own')
        scope.joins(:appointees).where("appointees.user_id=?", user.id)
      else
        scope.limit(0)
      end
    end

    # def previous_resolve
    #   if user.admin? || user.president? || user.advisor? || user.secretary? || user.observer?
    #     scope.all
    #   else
    #     scope.joins(:appointees).where("appointees.user_id=?", user.id)
    #   end
    # end
  end

end
