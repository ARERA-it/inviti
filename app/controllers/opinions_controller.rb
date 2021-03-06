class OpinionsController < ApplicationController
  before_action :set_opinion, only: [:show, :update]

  # PATCH/PUT /opinions/1.js
  # Qualcuno esprime un parere
  def update
    authorize @opinion
    respond_to do |format|
      if @opinion.update(opinion_params)
        @invitation = @opinion.invitation
        @asked_for_opinion = @invitation.users_who_was_asked_for_an_opinion.include?(current_user.id)
        format.js {}
      else
        format.js { render :js => "alert('Qualcosa è andato storto...')" }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_opinion
      @opinion = Opinion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def opinion_params
      params.require(:opinion).permit(:selection, :invitation_id)
    end
end
