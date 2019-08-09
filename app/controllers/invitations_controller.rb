class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :update, :update_delegation_notes, :destroy, :download_ics, :proposal_to_all_board_members, :audits, :email_decoded, :has_appointees, :update_participation, :cancel_participation]
  # return [{"id":"175","label":"John Wick","value":"John Wick"},{"id":"251","label":"Bruce Lee","val...


  def autocomplete_display_name
    term = params[:term]
    r = Group.sanitize_sql_array(["SELECT id, name as value, name as label, 'group' as type FROM groups WHERE name ilike ? UNION SELECT id, display_name as value, display_name as label, 'user' as type FROM users WHERE display_name ilike ? LIMIT 15", "%#{term}%", "%#{term}%"])
    h = Group.connection.select_all(r).to_hash
    # puts "----> #{r}"
    # puts "----> #{h}"
    render :json => h
  end

  def update_participation
    authorize @invitation
    respond_to do |format|
      decision = params[:invitation][:decision]
      comment  = params[:invitation][:comment] || ""
      if @invitation.update_participation(decision, comment, current_user)
        @feedback_hash = { msg: "Decisione salvata" }
      else
        @feedback_hash = { msg: "Qualcosa è andato storto" }
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


  def update_delegation_notes
    authorize @invitation
    respond_to do |format|
      if @invitation.update(delegation_notes: params[:invitation][:delegation_notes])
        @feedback_hash = { msg: "Osservazioni salvate con successo" }
      else
        @feedback_hash = { msg: "Qualcosa è andato storto" }
      end
      format.js
    end

  end


  # Modifica le info sull'incarico
  # TODO: lo togliamo? è una replica di update_participation ?
  # togli anche policy e js
  def want_participate
    authorize @invitation
    # find_appointee
    respond_to do |format|
      if params[:invitation][:decision]=="participate" # && params[:invitation][:appointee_id].nil?
      #   @feedback_hash = { msg: "L'utente non è stato trovato" }
      # else
        if @invitation.update(want_participate_params)
          # la notifica dell'incarico viene inviata dal modello (mail_to_assigned)
          puts "---> bene"
          @feedback_hash = { msg: "Dati salvati con successo" }
        else
          puts "---> errore: #{@invitation.errors.inspect}"
          @feedback_hash = { msg: "Qualcosa è andato storto" }
        end
      end
      format.js {}
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
    # @read_ids = current_user.invitations.pluck(:id) # invitation already read # TODO: obsolete
    @seen_invitations = current_user.seen_invitations

    # i = Invitation
    i = policy_scope(Invitation)
    sel = params['sel'] || 'to_be_filled'
    case sel

    when 'to_be_filled'
      i = i.order(created_at: :desc).no_info
      @sel = "da compilare"

    when 'to_be_assigned'
      i = i.order(from_date_and_time: :asc).to_be_assigned
      @sel = "da assegnare"

    when 'waitin'
      i = i.order(from_date_and_time: :asc).waitin
      @sel = "in assegnazione"

    when 'ready'
      i = i.order(from_date_and_time: :asc).are_assigned
      @sel = "assegnati"

    when 'archived'
      i = i.order("from_date_and_time DESC, created_at DESC").archived
      @sel = "archiviati"

    when 'all'
      i = i.order("from_date_and_time DESC, created_at DESC")
      @sel = "tutti"
    end
    @invitations = i.includes(:opinions, :comments, :contributions).with_attached_files
    @vis_mode = current_user.settings(:invitation).visualization_mode

    # Used by calendar
    if @vis_mode=="calendar"
      # @start_date = Date.today
      @start_date = Date.parse("2019-04-01")
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
    authorize @invitation
    if policy(@invitation).express_opinion? # policy(Opinion).update?
      @opinion   = @invitation.opinions.where(user: current_user).first || @invitation.opinions.create(user: current_user)
    end
    @other_opinions  = @invitation.opinions.where.not(user: current_user).where("selection >0")
    @comments        = @invitation.comments.order(created_at: :asc)
    @comment         = Comment.new(invitation: @invitation)
    @contributions   = @invitation.contributions
    @contribution    = Contribution.new(invitation: @invitation)
    @request_opinion = RequestOpinion.new(invitation: @invitation)
    # @invitation.user_display_name =

    @invitation.users << current_user # check invitation as 'read' # TODO: obsolete

    # puts "---> current_user: #{current_user.id}"
    # puts "---> @invitation: #{@invitation.id}"

    @seen_at = UserInvitation.create_or_touch(current_user, @invitation)
    # puts "---> @seen_at: #{@seen_at.inspect}"
  end



  def audits
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
        format.js {}
      else
        format.js { render :js => "alert('Qualcosa è andato storto...')" }
      end
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


  def download_ics
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

    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    def want_participate_params
      params.require(:invitation).permit(:delegation_notes) #, :decision, :user_display_name)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    # def appointee_params
    #   params.require(:invitation).permit(:decision, :appointee_id, :delegation_notes, :send_email) #, :user_display_name)
    # end
    def invitation_params
      params.require(:invitation).permit(:title, :location, :from_date_and_time_view, :to_date_and_time_view, :organizer, :notes, :appointee_id, :alt_appointee_name, :delegation_notes, :decision, :public_event, :org_category) #, :user_display_name)
    end
end
