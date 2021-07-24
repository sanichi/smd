module PaintingHelper
  def painting_order_menu(selected)
    opts = %w/title updated size/.map { |o| [t("painting.order.#{o}"), o] }
    options_for_select(opts, selected)
  end

  def painting_size(p)
    return "" unless p.width.present? && p.height.present?
    "%d x %d cm" % [p.width, p.height]
  end
end
