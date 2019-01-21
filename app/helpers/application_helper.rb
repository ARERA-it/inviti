module ApplicationHelper
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

end
