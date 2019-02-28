class InvitationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def update?
    !user.viewer?
  end

  def update_appointee?
    user.president?
  end


  # Vedere i pareri
  def view_opinion?
    user.admin? || user.president? || user.advisor?
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


end
