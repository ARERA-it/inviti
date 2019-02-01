class ContributionsController < ApplicationController
  before_action :set_contribution, only: [ :destroy ]

  # Add a contribution
  def create
    params = contribution_params
    @contribution = Contribution.new(contribution_params)
    @contribution.user = current_user
    respond_to do |format|
      if @contribution.save
        format.js
      else
        format.js { render js: "alert('Qualcosa è andato storto...');" }
      end
    end
  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @contribution.destroy
    respond_to do |format|
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
