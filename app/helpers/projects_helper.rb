module ProjectsHelper
  def advisor_groups_and_users
    Group.opinion_group_and_users.map do |group_name, users|
      users_string = users.any? ? users.join(', ') : "nessun utente definito"
      "#{group_name} (#{users_string})"
    end.join(', ')
  end
end
