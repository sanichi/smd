module PaintingHelper
  def painting_gallery_menu(selected, search=true)
    opts = Painting::GALLERY.map do |g|
      t = search ? t("painting.gallery")[0] + g.to_s : t("pages.gallery#{g}.title")
      [t, g]
    end
    opts.unshift [t("all"), ""] if search
    options_for_select(opts, selected)
  end

  def painting_media_menu(selected, search=true)
    opts = Painting::MEDIA.map{ |m| [t("painting.medias.#{m}"), m] }
    opts.unshift [t("all"), ""] if search
    options_for_select(opts, selected)
  end

  def painting_order_menu(selected)
    opts = %w/title stars size price updated/.map { |o| [t("painting.order.#{o}"), o] }
    options_for_select(opts, selected)
  end

  def painting_sold_menu(selected)
    opts = %w/available sold/.map { |s| [t("painting.#{s}"), s] }
    opts.unshift [t("all"), ""]
    options_for_select(opts, selected)
  end

  def painting_stars_menu(selected, search=true)
    opts = Painting::STARS.to_a.reverse.map do |s|
      t = (search ? t("symbol.star") : "") + s.to_s
      [t, s]
    end
    opts.unshift [t("all"), ""] if search
    options_for_select(opts, selected)
  end
end
