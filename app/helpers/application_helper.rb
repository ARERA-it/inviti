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
    content_tag(:span, nil, "data-livestamp" => dt.try(:iso8601), "data-toggle" => "tooltip", :title => localize(dt, format: :long))
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


  # param can be nil, a User object or
  #    an array of Appointee objects or User objects
  def avatars(param)
    content_tag :ul, class: 'avatars' do
      if param.nil?
        avatar nil
      else
        param = [param] if param.is_a? User
        case param.size
        when 0
          avatar nil
        when 1
          avatar param.first
        when 2
          capture do
            param.each_with_index do |appointee, idx|
              concat avatar(appointee)
            end
          end
        else
          w = param[1..-1].any?{|e| e.try(:app_waiting)}
          avatar(param.size, waiting: w) +
          avatar(param.first)
        end
      end
    end
  end

  # param can be an Appointee object, a User object, a number or nil
  def avatar(param, waiting: false)
    content_tag :li, class: "avatars__item" do
      case
      when param.nil?
        content_tag :span, "?", class: 'avatars__initials avatar__waiting'
      when param.is_a?(Integer)
        content_tag :span, "+#{param-1}", class: "avatars__others #{waiting ? 'avatar__waiting' : ''}"
      when param.is_a?(User)
        if param.image?
          image_tag param.image_url, class: "avatars__img"
        else
          content_tag :span, param.initials, class: 'avatars__initials', 'data-toggle': "tooltip", 'data-placement': "top", title: param.display_name
        end
      else # is an Appointee obj
        # puts "----> param: #{param.inspect}"
        if param.user.image?
          image_tag param.user.image_url, class: "avatars__img"
        else
          if param.app_waiting?
            content_tag :span, param.user.initials, class: "avatars__initials avatar__waiting", 'data-toggle': "tooltip", 'data-placement': "top", title: "#{param.user.display_name} (in attesa di risposta)"
          else
            content_tag :span, param.user.initials, class: "avatars__initials", 'data-toggle': "tooltip", 'data-placement': "top", title: param.user.display_name
          end
        end
      end
    end
  end



  def show_avatars(appointees, size: 50)
    if appointees.nil?
      content_tag :div, class: 'avatar-group-container' do
        show_avatar(nil, size: size)
      end
    else
      case appointees.size
      when 0
        content_tag :div, class: 'avatar-group-container' do
          show_avatar(nil, size: size)
        end
      when 1
        content_tag :div, class: 'avatar-group-container' do
          show_avatar(appointees.first.user, size: size)
        end
      else
        width = (appointees.size-1)*size*0.8
        content_tag :div, class: 'avatar-group-container', style: "width: #{width}px;" do
          capture do
            appointees.each_with_index do |appointee, idx|
              concat show_avatar(appointee.user, size: size)
            end
          end
        end
      end
    end
  end


  def show_avatar(user, size: 50, offset: 0)
    if user.nil?
      render partial: 'shared/no_avatar', locals: { size: size }
    else
      puts "-+-----> user's avatar: #{user.inspect}"
      if user.image?
        image_tag(user.image_url, class: "avatar-circle-#{size}")
      else
        render partial: 'shared/avatar', locals: { user: user, size: size, offset: offset }
      end
    end
  end







  def audit_changes(auditable_type, audited_changes)
    max_length = 200
    audited_changes.map do |k,v|
      if v.is_a? Array # update
        v1, v2 = v[0].to_s.truncate(max_length), v[1].to_s.truncate(max_length)
        v = v.to_s.truncate(max_length)
        if !v1.blank?
          content_tag(:span, tt("#{auditable_type.underscore}.#{k}"), "data-toggle": "tooltip", "data-html": "true", title: "da <span class='origin'>#{v1}</span> a <span class='final'>#{v2}</span>")
        else
          if !v2.blank?
            content_tag(:span, tt("#{auditable_type.underscore}.#{k}"), "data-toggle": "tooltip", "data-html": "true", title: "impostato a <span class='final'>#{v2}</span>")
          else
            nil
          end
        end
      else
        if !v.blank?
          content_tag(:span, tt("#{auditable_type.underscore}.#{k}"), "data-toggle": "tooltip", "data-html": "true", title: "impostato a <span class='final'>#{v}</span>")
        else
          nil
        end
      end
    end.compact.join(', ').html_safe
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




  def link_to_add_fields(name = nil, f = nil, association = nil, options = nil, html_options = nil, &block)
    # If a block is provided there is no name attribute and the arguments are
    # shifted with one position to the left. This re-assigns those values.
    f, association, options, html_options = name, f, association, options if block_given?

    options = {} if options.nil?
    html_options = {} if html_options.nil?

    if options.include? :locals
      locals = options[:locals]
    else
      locals = { }
    end

    if options.include? :partial
      partial = options[:partial]
    else
      partial = association.to_s.singularize + '_fields'
    end

    # Render the form fields from a file with the association name provided
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: 'new_record') do |builder|
      render(partial, locals.merge!( f: builder))
    end

    # The rendered fields are sent with the link within the data-form-prepend attr
    html_options['data-form-prepend'] = raw CGI::escapeHTML( fields )
    html_options['href'] = '#'

    content_tag(:a, name, html_options, &block)
  end
end
