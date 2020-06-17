class ContributionPolicy < ApplicationPolicy

  # Visualizzare un determinato contributo
  def view?
    create? ||
    role.can?('contribution', 'view')
  end


  # Aggiungere un contributo
  def create?
    role.can?('contribution', 'create') ||
    record.invitation.appointed_users.include?(user)
  end


  # Eliminare un contributo
  def destroy?
    # - admin, oppure
    # - autore (colui che l'ha creato), purché nel frattempo non
    #      sia diventato 'viewer'
    role.can?('contribution', 'destroy') ||
    record.user==user
  end
end
