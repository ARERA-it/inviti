module FollowUpActionsHelper

  def follow_up_action_descr(fua)
    username = fua&.user&.name || I18n.t(:undefined_user)
    I18n.t("follow_up_actions.description.#{fua.fu_action}", user: username)
  end
end
