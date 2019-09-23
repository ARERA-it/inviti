class RejectionsController < ApplicationController
  before_action :set_rej_user, except: :dismiss_all
  before_action :set_rejection_and_elem_id, except: :dismiss_all


  def dismiss
    respond_to do |format|
      if @rejection && @rej_user && @rej_user.update_attribute(:dismissed, true)
        format.js {}
      else
        format.js { render :js => "alert('Qualcosa è andato storto...')" }
      end
    end
  end

  def un_dismiss
    respond_to do |format|
      if @rejection && @rej_user && @rej_user.update_attribute(:dismissed, false)
        format.js { render 'dismiss' }
      else
        format.js { render :js => "alert('Qualcosa è andato storto...')" }
      end
    end
  end

  def dismiss_all
    respond_to do |format|
      @rej_user =
      if RejUser.where(user: current_user).update_all(dismissed: true)
        format.html { redirect_to dashboard_path, notice: 'Archiviati tutti correttamente.' }
      else
        format.html { redirect_to dashboard_path, alert: 'Qualcosa è andato storto.' }
      end
    end
  end

  private

  def set_rej_user
    @rej_user  = RejUser.find_by(rejection_id: params[:rejection_id], user_id: current_user.id)
  end

  def set_rejection_and_elem_id
    @rejection = Rejection.find(params[:rejection_id])
    @elem_id   = "rej-#{@rejection.id}"
  end
end
