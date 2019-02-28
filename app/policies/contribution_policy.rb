class ContributionPolicy < ApplicationPolicy

  # Aggiungere un contributo
  def create?
    !user.viewer?
  end

  # Eliminare un contributo
  def destroy?
    # - admin, oppure
    # - autore (colui che l'ha creato), purché nel frattempo non
    #      sia diventato 'viewer'
    user.admin? || (record.user.id==user.id && !user.viewer?)
  end
end
