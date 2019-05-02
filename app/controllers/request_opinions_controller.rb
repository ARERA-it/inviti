class RequestOpinionsController < ApplicationController
  # POST /request_opinion
  def create
    authorize :request_opinion
    p = request_opinion_params
    @invitation = Invitation.find(p[:invitation_id])
    @req_opinion = RequestOpinion.new(p)
    respond_to do |format|
      if p[:dest] && p[:dest].any?
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
      params.require(:request_opinion).permit(:invitation_id, dest: [])
    end
end
