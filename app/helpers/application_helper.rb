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

  def link_to_new(path)
    link_to path, class: 'btn btn-link' do
      content_tag(:i, "", class: "fas fa-plus fa-fw") + " Nuovo"
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

  def show_avatar(user, size: 100)
    if user.nil?
      render partial: 'shared/no_avatar', locals: { size: size }
    else
      if user.image?
        image_tag(user.image_url, class: "avatar-circle-#{size}")
      else
        render partial: 'shared/avatar', locals: { user: user, size: size }
      end
    end
  end

  def audit_changes(auditable_type, audited_changes)
    audited_changes.map do |k,v|
      if v.is_a? Array # update
        if v[0]
          content_tag(:span, tt("#{auditable_type.underscore}.#{k}"), "data-toggle": "tooltip", title: "da \"#{v[0]}\" a \"#{v[1]}\"")
        else
          content_tag(:span, tt("#{auditable_type.underscore}.#{k}"), "data-toggle": "tooltip", title: "impostato a \"#{v[1]}\"")
        end
      else
        content_tag(:span, tt("#{auditable_type.underscore}.#{k}"), "data-toggle": "tooltip", title: "impostato a \"#{v}\"")
      end
    end.join(', ').html_safe
  end

  # Translate the attribute, and ev. add a '*' if the attribute is mandatory
  # Example: tt('material.price'), or tt('material.description', mandatory: true)
  def tt(attribute, mandatory: false)
    translated = t("activerecord.attributes.#{attribute}")
    translated+=" *" if mandatory
    translated
  end

  def audit_model_action(audit)
    # a.auditable_type, a.action t(a.action, scope: :audit)
    "#{t(audit.action, scope: :audit)} #{t(audit.auditable_type.underscore, scope: 'activerecord.models')}"
  end
end
