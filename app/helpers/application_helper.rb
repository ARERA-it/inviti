module ApplicationHelper
  def fa_icon(name, style: :regular, options: "")
    s = case style
    when :regular
      "far"
    when :solid
      "fas"
    when :light
      "fal"
    else
      "far"
    end
    # fas fa-thumbs-up fa-fw
    content_tag(:i, nil, class: "#{s} fa-#{name} #{options}")
  end

  def flash_alert
    flash.map do |name, msg|
      content_tag(:div, msg, class: "alert alert-#{{ 'alert' => 'danger', 'notice' => 'success'}[name]}")
    end.join.html_safe
  end


  def yes_icon(bool)
    if bool
      content_tag(:i, "", class: "fas fa-check-circle fa-fw green")
    else
      content_tag(:span, "")
    end
  end

  def link_to_list(path)
    link_to path, class: 'btn btn-link' do
      content_tag(:i, "", class: "fas fa-list fa-fw") + " Elenco"
    end
  end

  def link_to_detail(path)
    link_to path, class: 'btn btn-link' do
      "Dettaglio scheda"
    end
  end

  def link_to_edit(path)
    link_to path, class: 'btn btn-link' do
      content_tag(:i, "", class: "fas fa-edit fa-fw") + " Modifica"
    end
  end

  def link_to_destroy(path)
    link_to path, method: :delete, data: { confirm: 'Vuoi eliminare il record?' }, class: "btn btn-link" do
      content_tag(:i, "", class: "fas fa-trash-alt fa-fw") + " Elimina"
    end
  end

  def livestamp(dt)
    content_tag(:span, nil, "data-livestamp" => dt.try(:iso8601))
  end

  # size: '' => standard, 'sm' => small
  def user_circle(user, size='')
    return nil if user.blank?
    if user.is_a? String
      initials = user.strip.split(" ")[0..1].map(&:first).join('').upcase
      name = user
    else
      initials = user.initials
      name = user.display_name
    end
    content_tag(:p, '', class: size, 'data-letters': initials, title: name)
  end

end
