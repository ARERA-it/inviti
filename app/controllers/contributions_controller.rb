class ContributionsController < ApplicationController
  before_action :set_contribution, only: [ :destroy ]

  # Add a contribution
  def create
    @contribution = Contribution.new(contribution_params)
    invitation = Invitation.find params[:contribution][:invitation_id]
    puts "---- inv: #{invitation}"
    authorize @contribution
    @contribution.user = current_user
    respond_to do |format|
      if @contribution.save
        @feedback_hash = { msg: "Contributo aggiunto" }
      else
        @feedback_hash = { msg: "Qualcosa è andato storto", kind: 'alert' }
      end
      @contribution.reload
      format.js
    end
  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize @contribution
    @contribution.destroy
    respond_to do |format|
      @feedback_hash = { msg: "Contributo eliminato con successo" }
      format.js
    end
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_contribution
      @contribution = Contribution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contribution_params
      params.require(:contribution).permit(:invitation_id, :title, :note, contribution_files: [])
    end

end
