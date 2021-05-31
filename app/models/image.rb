Image = Struct.new(:g, :s, :file, :px, :cm, :type, :sold, :price, :name) do
  def src(tn=false)
    "img/gallery%d/%s_%s.jpg" % [g, file, tn ? "100x100" : px]
  end

  def sold?
    sold == 's'
  end

  def valid_price?
    price && price.is_a?(Integer) && price > 10 && price < 10000
  end
end
