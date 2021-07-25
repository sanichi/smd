module PaintingHelper
  def painting_order_menu(selected)
    opts = %w/title updated size/.map { |o| [t("painting.order.#{o}"), o] }
    options_for_select(opts, selected)
  end

  def painting_media_menu(selected, search=true)
    opts = Painting::MEDIA.map{ |m| [t("painting.medias.#{m}"), m] }
    opts.unshift [t("any"), ""] if search
    options_for_select(opts, selected)
  end
end
