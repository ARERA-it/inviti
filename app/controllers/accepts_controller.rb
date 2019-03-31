class AcceptsController < ApplicationController
  layout 'no_sidebar'

  # TODO: authorization

  # successfull decision
  def show

  end

  def edit
    @accept = Accept.find_by(id: params[:id], token: params[:token])
    if @accept
      if @accept.not_yet?
        @invitation = @accept.invitation
        # @u = @i.appointee
      else
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
    @accept = Accept.find_by(id: params[:id], token: params[:token])
    respond_to do |format|
      if @accept.update(accept_params)
        format.html { redirect_to @accept }
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

    def accept_params
      params.require(:accept).permit(:comment, :decision)
    end
end
