class AppointeesController < ApplicationController
  before_action :set_invitation, only: [:create]
  before_action :set_appointee, only: [:edit_form]


  # User has clicked on 'other...' link on appointee timeline
  def edit_form
    authorize @appointee
    respond_to do |format|
      format.js {}
    end
  end


  # POST /appointees
  # POST /appointees.json
  # Un utente viene incaricato...
  def create
    authorize Appointee
    @appointees = Appointees.new(appointee_params, current_user)
    respond_to do |format|
      if @appointees.save
        format.js { render template: 'appointees/create.js.erb' }
      else
        format.js { render template: 'layouts/error_message.js.erb', locals: { object: @appointees.validated_obj, model: 'appointee' } }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointee
      @appointee = Appointee.find(params[:id])
    end

    def set_invitation
      @invitation = Invitation.find (params[:appointee] && params[:appointee][:invitation_id]) || params[:id]
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def appointee_params
      # "appointee"=>{"invitation_id"=>"13", "display_name"=>"Collegio (tranne mr. President)", "selected_id"=>"1", "user_or_group"=>"group", "ui_choice"=>"charge_w_consent", "comment"=>""}
      params.require(:appointee).permit([:invitation_id, :display_name, :selected_id, :user_or_group, :ui_choice, :comment])
    end
end
