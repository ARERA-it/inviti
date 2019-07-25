class UserRepliesController < ApplicationController
  layout 'no_sidebar'

  # successfull decision
  def show

  end

  def edit
    @user_reply = UserReply.find_by(id: params[:id], token: params[:token])
    if @user_reply
      @invitation = @user_reply.appointment_action.appointee.invitation
      if !@user_reply.not_yet?
        # already taken decision
        render 'decision_made'
      end


    else
      # Probabile token errato
      # redirect_to ERROR page
      render 'not_found'
    end
  end

  def update
    @user_reply = UserReply.find_by(id: params[:id], token: params[:token])
    respond_to do |format|
      if @user_reply.update(user_reply_params)
        format.html { redirect_to @user_reply }
        # format.json { render :show, status: :ok, location: @invitation }
        # format.js {}
      else
        format.html { render :edit }
        # format.json { render json: @invitation.errors, status: :unprocessable_entity }
        # format.js { render :js => "alert('Qualcosa è andato storto...')" }
      end
    end
  end


  private

    def user_reply_params
      params.require(:user_reply).permit(:comment, :status)
    end
end
