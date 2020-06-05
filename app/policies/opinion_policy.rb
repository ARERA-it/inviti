class OpinionPolicy < ApplicationPolicy

  def show?
    role.can?('opinion', 'show')
  end

  def express?
    role.can?('opinion', 'express') || User.to_ask_an_opinion.include?(user)
  end

  def update?
    express?
  end
end
