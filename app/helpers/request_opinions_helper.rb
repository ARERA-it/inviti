module RequestOpinionsHelper

  def req_opinion_message(req_op)
    if req_op.destination
      dest = req_op.destination.split(",").map{|e| I18n.t(e, scope: 'advisor_group')}.to_sentence
      "Richiesta inoltrata ai membri di #{dest}"
    else
      ""
    end
  end
end
