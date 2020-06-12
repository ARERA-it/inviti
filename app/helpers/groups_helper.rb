module GroupsHelper

  def group_users
    User.order(:display_name).map{|u| [u.id, u.display_name]}
  end


  def group_name_and_count(group)
    c = t('groups.group_count', count: group.users.count)
    "#{group.name} (#{c})"
  end
end
