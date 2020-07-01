class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:update, :update_delegation_notes, :destroy, :download_ical, :proposal_to_all_board_members, :audits, :email_decoded, :has_appointees, :update_participation, :cancel_participation]
  # return [{"id":"175","label":"John Wick","value":"John Wick"},{"id":"251","label":"Bruce Lee","val...


  def autocomplete_display_name
    term = params[:term]
    r = Group.sanitize_sql_array(["SELECT id, name as value, name as label, 'group' as type FROM groups WHERE name ilike ? UNION SELECT id, display_name as value, display_name as label, 'user' as type FROM users WHERE display_name ilike ? LIMIT 15", "%#{term}%", "%#{term}%"])
    h = Group.connection.select_all(r).to_hash
    render :json => h
  end


  # click on 'Participate' or 'Do not participate'
  def update_participation
    authorize @invitation
    respond_to do |format|
      decision = params[:invitation][:decision]
      comment  = params[:invitation][:comment] || ""
      if @invitation.update_participation(decision, comment, current_user)
        @feedback_hash = { msg: "Decisione salvata" }
      else
        if @invitation.past?
          @feedback_hash = { msg: "L'evento risulta scaduto", kind: 'alert' }
        else
          @feedback_hash = { msg: "Qualcosa è andato storto", kind: 'alert' }
        end
      end
      format.js
    end
  end

  def cancel_participation
    authorize @invitation
    respond_to do |format|
      decision = "do_not_participate"
      comment  = params[:invitation][:comment] || ""
      if @invitation.update_participation(decision, comment, current_user)
        format.html { redirect_to @invitation, notice: "La partecipazione è stata annullata con successo." }
        # format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :show }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # OK
  def update_delegation_notes
    authorize @invitation
    respond_to do |format|
      if @invitation.update(delegation_notes: params[:invitation][:delegation_notes])
        @feedback_hash = { msg: "Osservazioni salvate con successo" }
      else
        @feedback_hash = { msg: "Qualcosa è andato storto", kind: 'alert' }
      end
      format.js
    end
  end


  def email_decoded
    respond_to do |format|
      format.html { render html: @invitation.email_decoded.try(:html_safe) }
    end
  end

  def has_appointees
    respond_to do |format|
      bool = @invitation.nobody?
      format.html { render json: !bool }
    end

  end


  # GET /invitations
  # GET /invitations.json
  def index
    # puts "------> session[:invitation_index_sel]: #{session[:invitation_index_sel]}"
    # @read_ids = current_user.invitations.pluck(:id) # invitation already read # TODO: obsolete
    @seen_invitations = current_user.seen_invitations
    @sel = Invitation.validate_ui_index_selector(params['sel']) # status selection
    @sel_string = helpers.translate_invitation_ui_index_selector(@sel)

    session[:invitation_index_sel] = @sel

    i = policy_scope(Invitation)
      .filter_by_status(@sel)
      .filter_by_search(params[:search_string], params[:search_field])
      .page(params[:page])

    @invitations = i.includes(:opinions, :comments, :contributions, :appointees, :request_opinions).with_attached_files
    @vis_mode = current_user.settings(:invitation).visualization_mode # 'cards', 'list', 'calendar'

    # Used by calendar
    if @vis_mode=="calendar"
      @start_date = Date.today
      # @start_date = Date.parse("2019-04-01")
      @end_date = @start_date + 2.month
      @dfd = 1 # desired first day of calendar (1: monday)

      @inv_by_date = {}
      @invitations.each do |inv|
        if inv.from_date_and_time
          @inv_by_date[inv.from_date_and_time.to_date] ||= []
          @inv_by_date[inv.from_date_and_time.to_date] << inv
        end
      end
      @calendario = Calendario.new(@start_date, @end_date, dtd: 1, workdays: [1,2,3,4,5])
    end
  end

  # GET /invitations/1
  # GET /invitations/1.json
  def show
    @invitation = Invitation.find(params[:id])
    authorize @invitation
    # @invitation = policy_scope(Invitation.where(id: params[:id])).first
    # if @invitation.nil? || !@invitation.users_who_was_asked_for_an_opinion.include?(current_user.id)
    #   raise Pundit::NotAuthorizedError, "non hai i privilegi per eseguire l'azione"
    # end
    @opinion_auth = helpers.opinion_authorization(@invitation, current_user)

    # authorize @invitation
    # if policy(@invitation).express_opinion? # policy(Opinion).update?
    if @opinion_auth[:express_opinion] || @opinion_auth[:asked_for_opinion] # policy(Opinion).express?  # policy(Opinion).update?
      # @opinion   = @invitation.opinions.where(user: current_user).first || @invitation.opinions.create(user: current_user)
      @opinion   = @invitation.opinions.find_or_create_by(user: current_user)
    end
    @other_opinions  = @invitation.opinions.where.not(user: current_user).where("selection >0")
    @comments        = @invitation.comments.order(created_at: :asc)
    @comment         = Comment.new(invitation: @invitation)
    @contributions   = policy_scope(@invitation.contributions)
    @contribution    = Contribution.new(invitation: @invitation)
    @request_opinion = RequestOpinion.new(invitation: @invitation)
    @invitation.users << current_user # check invitation as 'read' # TODO: obsolete

    @seen_at = UserInvitation.create_or_touch(current_user, @invitation)
  end



  def audits
    authorize @invitation
    @seen_at = DateTime.parse(params[:seen_at])
    respond_to{|format| format.js}
  end


  # PATCH/PUT /invitations/1
  # PATCH/PUT /invitations/1.json
  # Modifica le info generali
  def update
    authorize @invitation
    respond_to do |format|
      @invitation.curr_user = current_user
      if @invitation.update(invitation_params)
        @feedback_hash = { msg: "Informazioni generali salvate correttamente" }
      else
        @feedback_hash = { msg: "Qualcosa è andato storto", kind: 'alert' }
      end
      format.js {}
    end
  end


  # Proposta di incarico a tutti i commissari
  def proposal_to_all_board_members
    authorize @invitation
    respond_to do |format|
      @invitation.proposal_to_all_board_members
      @feedback_hash = { msg: "Proposte inoltrate con successo" }
      format.js {}
    end
  end




  def update_expired_statuses
    case params['env']
    when 'dev'
      UpdateInvitationsJob.perform_later
    else
      # Rake::Task['inviti:check_emails'].invoke
      CheckNewEmailsJob.perform_later # perform_now ?
    end
    respond_to do |format|
      format.js {}
    end
  end


  # DELETE /invitations/1
  # DELETE /invitation/1.json
  def destroy
    authorize @invitation
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to invitations_path, notice: "L'invito è stato eliminato con successo." }
    end
  end


  # archive_invitation_path()
  def remove
    authorize @invitation
    respond_to do |format|
      if @invitation.remove!
        format.html { redirect_to invitations_path, notice: "L'invito è stato rimosso e spostato in archivio con successo." }
      else
        format.html { render :new }
      end
    end
  end


  def download_ical
    authorize @invitation
    file, filename = InvitationCalendar.generate_ics(@invitation, invitation_url(@invitation))
    send_data file,
      filename: filename,
      type: "text/calendar"
  end



  private


    def find_appointee
      appointee = User.find_by(display_name: params[:invitation].delete(:user_display_name))
      params[:invitation][:appointee_id] = appointee ? appointee.id : nil
    end

    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    def invitation_params
      params.require(:invitation).permit(:title, :location, :from_date_and_time_view, :to_date_and_time_view, :organizer, :notes, :appointee_id, :alt_appointee_name, :delegation_notes, :decision, :public_event, :org_category) #, :user_display_name)
    end
end
