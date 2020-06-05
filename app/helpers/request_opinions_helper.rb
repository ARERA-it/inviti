module RequestOpinionsHelper

  def req_opinion_message(req_op)
    if (groups = req_op.groups).any?
      groups_name = groups.map(&:name).to_sentence
      if req_op.user
        "Richiesta da #{req_op.user.display_name}, inoltrata ai membri di **#{groups_name}**"
      else
        "Richiesta inoltrata ai membri di **#{groups_name}**"
      end      
    else
      ""
    end
  end
end
