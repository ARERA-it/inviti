class FollowUpActionsController < ApplicationController


  def index
    @follow_up = FollowUp.find params[:follow_up_id]
    @actions = FollowUpAction.where(follow_up_id: params[:follow_up_id])
    respond_to do |format|
      format.js {}
    end
  end

  def create
    @fua = FollowUpAction.new(fua_params)
    # authorize @fua

    respond_to do |format|
      if @fua.save
        @fu = @fua.follow_up
        format.js {}
      else
        format.js { render template: 'follow_up_actions/creation_failed.js.erb'}
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fua
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fua_params
      params.require(:follow_up_action).permit(:follow_up_id, :fu_action, :comment).merge( user: current_user )
    end

end
