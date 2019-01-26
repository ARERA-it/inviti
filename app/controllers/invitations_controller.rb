class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :update]

  # GET /invitations
  # GET /invitations.json
  def index
    @read_ids = current_user.invitations.pluck(:id) # invitation already read

    i = Invitation
    case params['sel']
    when 'new'

      unread_ids = i.not_expired.pluck(:id) - @read_ids
      i = Invitation.where(id: unread_ids)
      @sel = "nuovi"

    when 'not_assigned'
      i = i.not_expired.not_assigned.participate_or_maybe
      @sel = "non assegnati"

    when 'running'
      i = i.not_expired.assigned #.info_provided
      @sel = "running"

    when 'archived'
      i = i.archived
      @sel = "archiviati"
    end
    @invitations = i.includes(:opinion, :comments).with_attached_files

  end

  # GET /invitations/1
  # GET /invitations/1.json
  def show
    @opinion  = @invitation.opinion  || @invitation.create_opinion(user: current_user)
    @comments = @invitation.comments.order(created_at: :asc)
    @comment  = Comment.new(invitation_id: @invitation.id)

    @invitation.users << current_user
  end

  # PATCH/PUT /invitations/1
  # PATCH/PUT /invitations/1.json
  def update
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
