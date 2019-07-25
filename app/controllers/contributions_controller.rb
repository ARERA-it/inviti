class ContributionsController < ApplicationController
  before_action :set_contribution, only: [ :destroy ]

  # Add a contribution
  def create
    @contribution = Contribution.new(contribution_params)
    authorize @contribution
    @contribution.user = current_user
    respond_to do |format|
      if @contribution.save
        format.js
      else
        # @model = 'contribution'
        # @object = @contribution
        format.js { render template: 'layouts/error_message.js.erb', locals: { object: @contribution, model: 'contribution' } }
      end
    end
  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize @contribution
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
