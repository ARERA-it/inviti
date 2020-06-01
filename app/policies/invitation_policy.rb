class InvitationPolicy < ApplicationPolicy

  def index?
    role.can?('invitation', 'index')
  end


  # user roles: :president, :advisor, :commissary, :secretary, :viewer, :admin
  def show?
    role.can?('invitation', 'show')
    # user.admin? ||
    # user.president? ||
    # user.advisor? ||
    # user.secretary? ||
    # user.observer? ||
    # record.appointed_users.include?(user) ||
    # record.users_who_was_asked_for_an_opinion.include?(user)
  end

  # Vedere i pareri
  def view_opinion?
    role.can?('invitation', 'view_opinion')
    # user.admin? ||
    # user.president? ||
    # user.advisor? ||
    # record.users_who_was_asked_for_an_opinion.include?(user)
  end

  # Vedere il pannello del designato
  def view_appointee?
    role.can?('invitation', 'view_appointee')
    # user.admin? ||
    # user.president? ||
    # user.advisor? ||
    # user.secretary? ||
    # user.observer? ||
    # record.appointed_users.include?(user)
  end

  # Vedere il pannello dei contributi
  def view_contributions?
    role.can?('invitation', 'view_contributions')
    # user.admin? ||
    # user.president? ||
    # user.advisor? ||
    # user.secretary? ||
    # user.observer? ||
    # record.appointed_users.include?(user)
  end

  # Vedere il pannello delle info generali
  def view_general_info?
    show?
  end

  # Vedere il pannello della email
  def view_email_info?
    show?
  end

  def show_audit?
    show? # TODO: davvero?
  end

  def express_opinion?
    user.admin? ||
    user.advisor? ||
    record.users_who_was_asked_for_an_opinion.include?(user)
  end

  def update_participation?
    user.admin? || user.president?
  end

  def cancel_participation?
    update_participation?
  end

  def update_general_info?
    user.admin? ||
    user.president? ||
    user.secretary?
  end





  # Le info generali
  def update?
    show?
  end

  def usual_and_particular
    user.admin? ||
    user.president? ||
    user.advisor? ||
    user.secretary? ||
    record.users_who_was_asked_for_an_opinion.include?(user)
  end

  def update_delegation_notes?
    user.admin? || user.president?
  end


  # Le info sull'incarico
  # TODO: obsoleto
  def want_participate?
    return true if user.admin?
    return false if !user.president?

    case Project.primo.president_can_assign
    when "at_least_one_opinion"
      User.any_advisor_expressed_an_opinion_on record
    when "all_opinions"
      User.all_advisor_expressed_an_opinion_on record
    else
      true
    end
  end



  def destroy?
    role.can?('invitation', 'destroy')
    # return true  if user.admin?
    # return true  if user.secretary? && (record.no_info? || record.info?)
  end

  def download_ics?
    show?
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
