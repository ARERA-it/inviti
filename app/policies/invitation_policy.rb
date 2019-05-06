class InvitationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    if user.viewer?
      record.appointee_id == user.id
    else
      true
    end
  end

  # Le info generali
  def update?
    if user.viewer?
      record.appointee_id == user.id
    else
      true
    end
  end

  # Le info sull'incarico
  def update_appointee?
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


  def update_general_info?
    if user.viewer?
      record.appointee_id == user.id
    else
      true
    end
  end

  def destroy?
    if user.admin? || (record.no_info? && !user.viewer?)
      true
    end
  end

  def download_ics?
    if user.viewer?
      record.appointee_id == user.id
    else
      true
    end
  end


  # Vedere i pareri
  def view_opinion?
    user.admin? || user.president? || user.advisor?
  end


  def proposal_to_all_board_members?
    user.admin? || user.president?
  end

  # Esprimere un parere  ->  v. opinion_policy
  # Aggiungere un commento (dopo il parere)  ->  v. comment_policy

  # Vedere il pannello del designato
  def view_appointee?
    true
  end

  # Vedere il pannello dei contributi
  def view_contributions?
    true
  end

  # Vedere il pannello delle info generali
  def view_general_info?
    true
  end

  # Vedere il pannello della email
  def view_email_info?
    true
  end

  class Scope < Scope
    def resolve
      if user.viewer?
        puts "------>>>>><<<<<<------"
        scope.where(appointee_id: user.id)
      else
        scope.all
      end
    end
  end

end
