class RequestOpinionsController < ApplicationController
  before_action :set_invitation

  # POST /request_opinion
  def create
    authorize :request_opinion
    p = request_opinion_params # "request_opinion"=>{"invitation_id"=>"52", "group_ids"=>["4", "1"]}
    @req_opinion = RequestOpinion.new(p)
    respond_to do |format|
      if p[:group_ids] && p[:group_ids].any?
        if @req_opinion.save
          @feedback_hash = { msg: "Richiesta inviata con successo" }
        else
          @feedback_hash = { msg: "Qualcosa è andato storto", txt_class: 'alert' }
        end
      else
        @feedback_hash = { msg: "Selezionare almeno un destinatario" }
      end
      format.js {}
    end
  end


  private
    def request_opinion_params
      params.require(:request_opinion).permit(:invitation_id, group_ids: [])
    end

    def set_invitation
      @invitation = Invitation.find(params[:request_opinion][:invitation_id])
    end

end
