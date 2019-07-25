module GroupsHelper

  def group_users
    User.order(:display_name).map{|u| [u.id, u.display_name]}
  end
end
