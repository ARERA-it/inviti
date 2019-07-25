module RedcarpetHelper


  def redcarpet_render(text, p_wrap: false)
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    if p_wrap
      markdown.render(text).html_safe
    else
      markdown.render(text).rc_unwrap_p.html_safe
    end
  end
end
