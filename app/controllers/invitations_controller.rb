class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :update, :update_appointee]

  # GET /invitations
  # GET /invitations.json
  def index
    @read_ids = current_user.invitations.pluck(:id) # invitation already read

    i = Invitation
    sel = params['sel'] || 'to_be_filled'
    case sel
    when 'new'
      unread_ids = i.not_expired.pluck(:id) - @read_ids
      i = Invitation.where(id: unread_ids)
      @sel = "nuovi"

    when 'to_be_filled'
      i = i.to_be_filled
      @sel = "da compilare"

    when 'not_assigned'
      i = i.not_assigned
      @sel = "da assegnare"

    when 'running'
      i = i.running
      @sel = "running"

    when 'archived'
      i = i.archived
      @sel = "archiviati"
    end
    @invitations = i.includes(:opinion, :comments, :contributions).with_attached_files
    @vis_mode = current_user.settings(:invitation).visualization_mode

    # Used by calendar
    if @vis_mode=="calendar"
      @start_date = Date.today
      @end_date = Date.today + 2.month
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
    @opinion  = @invitation.opinion  || @invitation.create_opinion(user: current_user)
    @comments = @invitation.comments.order(created_at: :asc)
    @comment  = Comment.new(invitation_id: @invitation.id)
    @contributions = @invitation.contributions
    @contribution = @invitation.contributions.build

    @invitation.users << current_user # check invitation as 'read'
  end

  # PATCH/PUT /invitations/1
  # PATCH/PUT /invitations/1.json
  def update
    authorize @invitation
    respond_to do |format|
      if @invitation.update(invitation_params)
        format.html { redirect_to @invitation, notice: 'Dati modificati con successo.' }
        format.json { render :show, status: :ok, location: @invitation }
        format.js {}
      else
        format.html { render :edit }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
        format.js { render :js => "alert('Qualcosa è andato storto...')" }
      end
    end
  end


  def update_appointee
    authorize @invitation
    respond_to do |format|
      if @invitation.update(invitation_params)
        # format.html { redirect_to @invitation, notice: 'Dati modificati con successo.' }
        # format.json { render :show, status: :ok, location: @invitation }
        format.js {}
      else
        # format.html { render :edit }
        # format.json { render json: @invitation.errors, status: :unprocessable_entity }
        format.js { render :js => "alert('Qualcosa è andato storto...')" }
      end
    end

  end


  def update_invitation_expired_statuses
    UpdateInvitationsJob.perform_later
    redirect_to invitations_path(sel: 'running')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:title, :location, :from_date_and_time_view, :to_date_and_time_view, :organizer, :notes, :appointee_id, :alt_appointee_name, :delegation_notes, :decision)
    end
end
