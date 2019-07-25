module RequestOpinionsHelper

  def req_opinion_message(req_op)
    if (groups = req_op.groups).any?
      groups_name = groups.map(&:name).to_sentence
      "Richiesta inoltrata ai membri di **#{groups_name}**"
    else
      ""
    end
  end
end
