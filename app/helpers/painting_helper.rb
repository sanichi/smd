module PaintingHelper
  def painting_order_menu(selected)
    opts = %w/title updated size/.map { |o| [t("painting.order.#{o}"), o] }
    options_for_select(opts, selected)
  end

  def painting_media_menu(selected, search=true)
    opts = Painting::MEDIA.map{ |m| [t("painting.medias.#{m}"), m] }
    opts.unshift [t("all"), ""] if search
    options_for_select(opts, selected)
  end

  def painting_gallery_menu(selected, search=true)
    opts = Painting::GALLERY.map{ |g| [t("painting.gallery")[0] + g.to_s, g] }
    opts.unshift [t("all"), ""] if search
    options_for_select(opts, selected)
  end

  def painting_sold_menu(selected)
    opts = %w/available sold/.map { |s| [t("painting.#{s}"), s] }
    opts.unshift [t("all"), ""]
    options_for_select(opts, selected)
  end
end
