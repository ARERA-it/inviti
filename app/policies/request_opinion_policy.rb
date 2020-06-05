class RequestOpinionPolicy < ApplicationPolicy

  # Can ask for an opinion (via e-mail)
  def create?
    role.can?('request_opinion', 'create')
  end

  def show?
    role.can?('request_opinion', 'show')
  end
end
