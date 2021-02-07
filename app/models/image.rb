Image = Struct.new(:g, :s, :file, :px, :cm, :type, :name) do
  def src(tn=false)
    "img/gallery%d/%s_%s.jpg" % [g, file, tn ? "100x100" : px]
  end

  def alt(full=false)
    if full
      details = I18n.t('type.' + type)
      if cm =~ /\A([1-9]\d*)x([1-9]\d*)\z/
        details += ", #{$1} × #{$2} cm"
      end
      "<strong>#{name}</strong> (#{details})".html_safe
    else
      name
    end
  end
end
