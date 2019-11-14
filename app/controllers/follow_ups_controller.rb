class FollowUpsController < ApplicationController
  before_action :set_follow_up_user, except: :dismiss_all
  before_action :set_follow_up_and_elem_id, except: :dismiss_all


  def dismiss
    respond_to do |format|
      if @follow_up && @follow_up_user && @follow_up_user.update_attribute(:dismissed, true)
        format.js {}
      else
        format.js { render :js => "alert('Qualcosa è andato storto...')" }
      end
    end
  end

  def un_dismiss
    respond_to do |format|
      if @follow_up && @follow_up_user && @follow_up_user.update_attribute(:dismissed, false)
        format.js { render 'dismiss' }
      else
        format.js { render :js => "alert('Qualcosa è andato storto...')" }
      end
    end
  end

  def dismiss_all
    respond_to do |format|
      @follow_up_user =
      if FollowUpUser.where(user: current_user).update_all(dismissed: true)
        format.html { redirect_to dashboard_path, notice: 'Archiviati tutti correttamente.' }
      else
        format.html { redirect_to dashboard_path, alert: 'Qualcosa è andato storto.' }
      end
    end
  end

  private

  def set_follow_up_user
    @follow_up_user  = FollowUpUser.find_by(follow_up_id: params[:follow_up_id], user_id: current_user.id)
  end

  def set_follow_up_and_elem_id
    @follow_up = FollowUp.find(params[:follow_up_id])
    @elem_id   = "fu-#{@follow_up.id}"
  end

end
