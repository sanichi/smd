module PaintingHelper
  def painting_order_menu(selected)
    opts = [
      [t("painting.order.title"),     "title"],
      [t("painting.order.updated"), "updated"],
    ]
    options_for_select(opts, selected)
  end
end
