Image = Struct.new(:g, :s, :file, :size, :type, :name) do
  def src(tn=false)
    "img/gallery%d/%s_%s.jpg" % [g, file, tn ? "100x100" : size]
  end

  def alt(full=false)
    if full
      "<strong>#{name}</strong> (#{I18n.t('type.' + type)})".html_safe
    else
      name
    end
  end
end
