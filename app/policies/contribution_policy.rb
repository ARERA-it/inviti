class ContributionPolicy < ApplicationPolicy

  # Aggiungere un contributo
  def create?
    user.admin? ||
    user.president? ||
    user.advisor? ||
    user.secretary? ||
    record.invitation.appointed_users.include?(user)
  end

  # Eliminare un contributo
  def destroy?
    # - admin, oppure
    # - autore (colui che l'ha creato), purché nel frattempo non
    #      sia diventato 'viewer'
    user.admin? ||
    record.user==user
  end
end
