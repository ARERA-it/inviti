class OpinionPolicy < ApplicationPolicy
  # TODO: usare i gruppi per stabilire chi può creare o vedere i pareri
  # Esprimere un parere

  def show?
    user.advisor? ||
    user.admin? ||
    user.president?
  end

  # see policy(record.invitation).express_opinion?
  def update?
    user.advisor? ||
    user.admin? ||
    record.invitation.users_who_was_asked_for_an_opinion.include?(user)
  end

  # Can ask for an opinion (via e-mail)
  def request?
    user.president? ||
    user.admin?
  end

  def create?
    user.advisor? ||
    user.admin?
  end
end
