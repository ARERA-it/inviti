module UserInteractionsHelper

  def interaction_interval(user_interaction_aggreg_row)
    t1 = user_interaction_aggreg_row.start_time
    t2 = user_interaction_aggreg_row.end_time
    d1 = t1.to_date
    if d1==t2.to_date
      h1 = t1.strftime("%H:%M")
      h2 = t2.strftime("%H:%M")
      if h1==h2
        "#{l d1, format: :long} alle #{h1}"
      else
        "#{l d1, format: :long} dalle #{h1} alle #{h2}"
      end
    else
      "dal #{l t1, format: :long} al #{l t2, format: :long}"
    end
  end
end
