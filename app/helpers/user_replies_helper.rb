module UserRepliesHelper


  def appointment_reply_title(kind, invitation_title)
    case kind
    when 'direct_appoint'
      "Incarico diretto all'evento \"#{invitation_title}\""
    when 'appoint'
      "Invito all' evento \"#{invitation_title}\""
    when 'proposal'
      "Proposta di partecipazione all'evento \"#{invitation_title}\""
    end
  end

  def appointment_reply_question(kind)
    case kind
    when 'direct_appoint'
      "Non puoi partecipare?"
    when 'appoint'
      "Accetti l'invito?"
    when 'proposal'
      "Saresti interessato a partecipare?"
    end
  end


  def appointment_reply_selection(kind)
    case kind
    when 'direct_appoint'
      [["No, non posso partecipare", 'rejected']]
    when 'appoint'
      [["Sì, accetto l'invito", 'accepted'],["No, rifiuto l'invito", 'rejected']]
    when 'proposal'
      [["Sì, mi interessa", 'accepted'],["No, non mi interessa", 'rejected']]
    end
  end
end
