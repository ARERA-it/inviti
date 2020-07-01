class PagePolicy < ApplicationPolicy

  def dashboard?
    true
  end

  def invitation_stats?
    role.can?('page', 'invitation_stats')
  end

  def web_app_stats?
    role.can?('page', 'web_app_stats')
  end

  class Scope < Scope

    def resolve_follow_ups(page:)
      if role.can?('page', 'follow_ups')
        scope.search_for(user: user, page: page)
      else
        nil
      end
    end
  end

end
