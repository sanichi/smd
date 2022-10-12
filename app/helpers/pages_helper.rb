module PagesHelper
  class CustomRenderer < Redcarpet::Render::HTML
    def link(link, title, alt_text)
      if external?(link)
        '<a href="%s" target="%s">%s</a>' % [link, I18n.t("external"), alt_text]
      else
        '<a href="%s">%s</a>' % [link, alt_text]
      end
    end

    def autolink(link, link_type)
      if external?(link)
        '<a href="%s" target="%s">%s</a>' % [link, I18n.t("external"), link]
      else
        '<a href="%s">%s</a>' % [link, link]
      end
    end

    private

    def external?(link)
      link.match?(/\Ahttps?:\/\//)
    end
  end

  def to_html(text)
    return "" unless text.present?
    renderer = CustomRenderer.new(filter_html: false)
    options =
    {
      autolink: true,
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      strikethrough: true,
      superscript: true,
      tables: true,
      underline: true,
    }
    text.gsub!("red_dot", dot(:sold))
    text.gsub!("green_dot", dot(:avail))
    text.gsub!("blue_dot", dot(:print))
    text.gsub!("yellow_dot", dot(:sale))
    markdown = Redcarpet::Markdown.new(renderer, options)
    markdown.render(text).html_safe
  end
end
