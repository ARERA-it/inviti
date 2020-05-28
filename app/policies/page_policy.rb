class PagePolicy < ApplicationPolicy

  def dashboard?
    true
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
