module ProjectsHelper
  def advisor_groups_and_users_old
    User.active_advisor_groups_with_users.to_a.map do |lev1|
      users = lev1.last
      users_string = users.any? ? users.map(&:display_name).join(', ') : "nessun utente definito"
      "#{t(lev1.first, scope: :advisor_group)} (#{users_string})"
    end.join(", ")
  end


  def advisor_groups_and_users
    Group.opinion_group_and_users.map do |group_name, users|
      users_string = users.any? ? users.join(', ') : "nessun utente definito"
      "#{group_name} (#{users_string})"
    end.join(', ')
  end
end
