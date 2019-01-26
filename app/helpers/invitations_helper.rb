module InvitationsHelper
  def location_icon(loc)
    fa_icon(:compass)+
    if loc
      content_tag(:span, loc, class: "with-location")
    else
      content_tag(:span, "...", class: "no-location")
    end
  end

  def calendar_icon(dt)
    fa_icon(:'calendar-alt')+
    content_tag(:span, formatta_data(dt))
  end

  def formatta_data(d)
    if d
      I18n.localize(d.to_date, format: :card)
    else
      "..." # I18n.t(:sometime)
    end
  end

  def formatta_dataora(d)
    if d
      I18n.localize(d, format: :card)
    else
      I18n.t(:sometime)
    end
  end

  # [ :undefined, :do_not_participate, :president_must_participate, :someone_else_must_participate ]
  def approve_icon(selection)
    return "" if selection.nil?
    case selection.to_sym
    when :do_not_participate
      fa_icon('thumbs-down', options: "fa-fw fa-lg")
    when :president_must_participate
      fa_icon('thumbs-up', style: :solid, options: "fa-fw fa-lg")
    when :someone_else_must_participate
      fa_icon('thumbs-up', style: :regular, options: "fa-fw fa-lg")
    end
  end

  def chat_position(current_user, comment_user)
    if current_user.id==comment_user.id
      "right"
    else
      "left"
    end
  end

  def rev_chat_position(current_user, comment_user)
    if current_user.id==comment_user.id
      "left"
    else
      "right"
    end
  end

  def ribbon(inv)
    # basic_ribbon
    if inv.do_not_participate?
      ribbon_do_not_participate
    elsif inv.participate?
      ribbon_participate

    # elsif new_invitation
    #   ribbon_new
    end
  end

  def basic_ribbon
    content_tag(:div, class: "ribbon ribbon-bottom-right") do
      content_tag(:span, "ribbon")
    end
  end

  def ribbon_new
    content_tag(:div, class: "ribbon ribbon-bottom-right") do
      content_tag(:span, "nuovo")
    end
  end


  def ribbon_do_not_participate
    content_tag(:div, class: "ribbon ribbon-bottom-right red") do
      content_tag(:span, "declinato")
    end
  end

  def ribbon_participate
    content_tag(:div, class: "ribbon ribbon-bottom-right green") do
      content_tag(:span, "accettato")
    end
  end

end
