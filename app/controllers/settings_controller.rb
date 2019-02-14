class SettingsController < ApplicationController

  # GET /settings/update
  def update
    current_user.settings(:invitation).update_attributes! visualization_mode: params[:vis_mode]
    respond_to do |format|
      format.js { head :ok }
    end

  end

end
