module ContactHelper
  def contact_order_menu(selected)
    opts = %w/email first_name last_name/.map { |o| [t("contact.#{o}"), o] }
    options_for_select(opts, selected)
  end
end