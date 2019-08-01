module AppointeesHelper

  def appointee_status_label(status)
    s = case status
    when "proposal", "prop_accepted", "prop_refused"
      "proposta"
    when "app_waiting", "app_refused", "app_accepted", "app_w_consent"
      "incarico"
    when "canceled"
      "annullato"
    end
    c = case status
    when "proposal", "app_waiting"
      "secondary"
    when "canceled", "prop_refused", "app_refused"
      "danger"
    when "prop_accepted", "app_accepted", "app_w_consent"
      "success"
    end
    content_tag(:span, s, class: "badge badge-#{c}")
  end


  def appointee_status_detail(status)
    s = case status
    when "proposal"
      "in attesa di una risposta"
    when "prop_accepted"
      "proposta accettata"
    when "prop_refused"
      "proposta rifiutata"
    when "app_waiting"
      "in attesa di una risposta"
    when "app_refused"
      "incarico rifiutato"
    when "app_accepted"
      "incarico accettato"
    when "app_w_consent"
      "incarico diretto"
    when "canceled"
      "annullato"
    end
    # content_tag(:span, s, class: "badge badge-secondary")
    s
  end

#  enum status: [:prop_waiting, :prop_accepted, :prop_refused, :app_waiting, :app_refused, :app_accepted, :direct_app_waiting, :direct_app_accepted, :direct_app_refused, :canceled]

  def appointee_colored_icon(a)
    fa_icon, title = case
                    when a.status.include?("prop_")
                      ["fa-question-circle", "Proposta"]
                    when a.status=="canceled"
                      ["fa-times-circle", "Proposta/incarico annullato"]
                    else
                      ["fa-suitcase-rolling", "Incarico"]
                    end

    fa_color = case
              when a.status=="direct_app"
                "green"
              when a.status.include?("_waiting")
                "grey"
              when a.status.include?("_accepted")
                "green"
              when a.status.include?("_refused")
                "red"
              when a.status=="canceled"
                "red"
              else
                "light-grey"
              end

    content_tag(:i, nil, class: "appointee-colored-icon fas #{fa_icon} fa-lg #{fa_color}", data: { toggle: "tooltip", placement: "top" }, title: title)
  end
end
