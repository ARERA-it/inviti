class InvitationPolicy < ApplicationPolicy

  # def index?
  #   role.can?('invitation', 'index')
  # end


  # user roles: :president, :advisor, :commissary, :secretary, :viewer, :admin
  # def show?
  #   role.can?('invitation', 'show')
  # end

  def audits?
    role.can?('invitation', 'audits')
  end

  # Vedere il pannello della persona incaricata
  def view_appointee?
    role.can?('invitation', 'view_appointee')
  end

  # participate or not?
  def update_participation?
    role.can?('invitation', 'update_participation')
  end


  def update_delegation_notes?
    role.can?('appointee', 'change_note') # invitation#delegation_notes
  end


  # Show contributions counter on invitation card or list
  def view_contributions?
    # - the correct one:
    # policy_scope(record.contributions).any? || policy(Contribution).create?(record)
    # - quello rapido ma impreciso
    true
  end

  # Vedere il pannello della email
  def view_email_info?
    role.can?('invitation', 'view_email_info')
  end


  def update? # Le info generali
    role.can?('invitation', 'update')
  end

  # destroy an invitation
  def destroy?
    role.can?('invitation', 'destroy')
  end

  def download_ical?
    role.can?('invitation', 'download_ical')
  end




  def proposal_to_all_board_members?
    user.admin? || user.president?
  end

  # Esprimere un parere  ->  v. opinion_policy
  # Aggiungere un commento (dopo il parere)  ->  v. comment_policy


  def show?
    # can show record if:
    # - by role can show_all
    # - user is between appointees
    # - his opinion was requested
    role.can?('invitation', 'show_all') || record.appointees.where("appointees.user_id=?", user.id).any? || record.request_opinions.map{|ro| ro.groups_users.include?(user)}.any?
  end



  class Scope < Scope
    def resolve
      if role.can?('invitation', 'show_all')
        scope.all
      else
        scope.joins(:appointees).where("appointees.user_id=?", user.id) # here no check if user opinion was requested
      end
    end
  end

end
