
class Appointees
  attr_reader :display_name, :selected_id, :user_or_group, :ui_choice, :comment
  attr_reader :validated_obj

  def initialize(params, current_user)
    @current_user = current_user
    @arr = []
    @validated_obj = nil
    a = Appointee.new(params)
    a.from_ui = true
    if a.invalid?
      puts a.errors.inspect
      @validated_obj = a
    end

    params.each { |name, value| instance_variable_set("@#{name}", value) }

    if @user_or_group=="group"
      @group = Group.find @selected_id

      invitation_appointees = Invitation.find(@invitation_id).appointees
      @group.users.each do |user|
        @arr << (invitation_appointees.find{|a| a.user_id==user.id} || Appointee.new(params.merge(user_id: user.id)))
      end

    else
      # a user selected
      @user = User.find @selected_id
      a.user = @user
      @arr << (Invitation.find(@invitation_id).appointees.find{|a| a.user_id==@user.id} || a)
    end
  end


  def save
    if @validated_obj
      return false
    end

    @arr.each do |a|
      a.save
      # TODO: re-use an existing action (same kind)?
      action = a.actions.create(user: @current_user, kind: decode_ui_choice(ui_choice), comment: comment)
    end
  end


  private

  def decode_ui_choice(ui_choice)
    { "send_proposal" => :proposal, "charge_w_email" => :appoint, "charge_w_consent" => :direct_appoint, "cancel" => :canceled }.fetch(ui_choice)
  end
end
