module InvitationsHelper

  def translate_invitation_ui_index_selector(sel)
    case sel
    when 'to_be_assigned'
      "da assegnare"
    when 'waitin'
      "in assegnazione"
    when 'ready'
      "pronti"
    when 'archived'
      "archiviati"
    when 'all'
      "tutti"
    else # 'to_be_filled'
      "da compilare"
    end
  end


  def new_invitation_badge(invitation, current_user, hash)
    case invitation.new_or_changed?(current_user, hash: nil)
    when :new
      content_tag(:span, "nuovo", class: "badge badge-primary")
    when :changed
      content_tag(:span, "modificato", class: "badge badge-primary")
    when :no_changes

    end
  end

  def status_badge(inv)
    if inv.at_work? || inv.ibrid?
      content_tag(:span, "in attesa", class: "badge badge-assigned")
    elsif inv.one_or_more?
      content_tag(:span, "accettato", class: "badge badge-accepted")
    elsif inv.declined?
      content_tag(:span, "declinato", class: "badge badge-declined")
    elsif inv.past?
      content_tag(:span, "scaduto", class: "badge badge-past")
    end
  end

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

  def formatta_data(d, alt="...")
    if d
      I18n.localize(d.to_date, format: :card)
    else
      alt # I18n.t(:sometime)
    end
  end

  def formatta_dataora(d, alt=I18n.t(:sometime))
    if d
      I18n.localize(d, format: :card)
    else
      alt
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
    if inv.declined?
      ribbon_declined
    elsif inv.past?
      ribbon_past
    end
  end

  def basic_ribbon
    content_tag(:div, class: "ribbon ribbon-bottom-right") do
      content_tag(:span, "ribbon")
    end
  end

  def ribbon_declined
    content_tag(:div, class: "ribbon ribbon-bottom-right red") do
      content_tag(:span, "declinato")
    end
  end

  def ribbon_past
    content_tag(:div, class: "ribbon ribbon-bottom-right dark-red") do
      content_tag(:span, "scaduto")
    end
  end

  def ribbon_accepted
    content_tag(:div, class: "ribbon ribbon-bottom-right green") do
      content_tag(:span, "accettato")
    end
  end

  def ribbon_assigned
    content_tag(:div, class: "ribbon ribbon-bottom-right light-green") do
      content_tag(:span, "in attesa")
    end
  end


  def icon_for_opinion(op)
    approve_icon(op.try(:selection))
  end

  def icon_for_opinions(opinions)
    # icon_for_opinion(opinions.first).html_safe if opinions.first
    content_tag(:span, class: "icon-wrapper") do
      opinions.each do |op|
        concat icon_for_opinion(op)
      end
    end
  end


  def icon_for_comments(comments)
    if (size = comments.size) > 0
      title = size==1 ? "1 commento" : "#{size} commenti"
      content_tag(:span, class: "icon-wrapper", title: title) do
        content_tag(:i, '', class: "fas fa-comment fa-fw fa-lg") + "#{size}"
      end
    end
  end


  def icon_for_contributions(contributions)
    if (size = contributions.size) > 0
      title = size==1 ? "1 contributo" : "#{size} contributi"
      content_tag(:span, class: "icon-wrapper", title: title) do
        content_tag(:i, '', class: "fas fa-plane fa-fw fa-lg") + "#{size}"
      end
    end
  end

  def assignment_step_msg(as, truncate_at: nil)
    if truncate_at
      livestamp(as.timestamp)+" #{as.description.truncate(truncate_at)}"
    else
      livestamp(as.timestamp)+" #{as.description}"
    end
  end

  def invitation_timestamp(inv)
    if inv.to_date_and_time.nil?
      formatta_dataora inv.from_date_and_time
    else
      if inv.from_date_and_time.to_date==inv.to_date_and_time.to_date
        # same date
        from_tm = I18n.localize(inv.from_date_and_time, format: :hh_mm)
        to_tm   = I18n.localize(inv.to_date_and_time, format: :hh_mm)
        I18n.translate(:date_from_tm_to_tm, date: formatta_data(inv.from_date_and_time), from_tm: from_tm, to_tm: to_tm)
      else
        # two or more days
        from_dt = formatta_dataora @invitation.from_date_and_time
        to_dt   = formatta_dataora @invitation.to_date_and_time
        I18n.translate(:from_dt_to_dt, from_dt: from_dt, to_dt: to_dt)
      end
    end
  end



  def appointee_disabled_fields_message(invitation)
    arr = []
    if invitation.no_info?
      arr << "Occorre compilare le informazioni generali: titolo, luogo e data"
    end
    if @project.at_least_one_opinion? && !User.any_advisor_expressed_an_opinion_on(invitation)
      arr << "È necessario che sia espresso almeno un parere"
    end
    if @project.all_opinions? && !User.all_advisor_expressed_an_opinion_on(invitation)
      arr << "È necessario che sia espresso almeno un parere da ciascun gruppo (#{User.active_advisor_groups.map{|g| t(g, scope: :advisor_group)}.join(', ')})"
    end
    if arr.any?
      content_tag(:div, class: "alert alert-warning", role: "alert") do
        content_tag(:p, "I campi sono temporaneamente disabilitati!") +
        content_tag(:ul) do
          capture do
            arr.each do |s|
              concat content_tag(:li, s)
            end
          end
        end
      end
    end
  end


  def appointee_ui_choices(current_status=nil)
    Appointee.ui_choices(current_status).map{|e| [e, I18n.t(e, scope: 'appointee_ui_choices').html_safe, I18n.t(e, scope: 'appointee_ui_choices_help')]}
  end


  def appointee_ui_choices2
    Appointee.ui_choices2.map{|e| [e, I18n.t(e, scope: 'appointee_ui_choices').html_safe, I18n.t(e, scope: 'appointee_ui_choices_help')]}
  end
end
