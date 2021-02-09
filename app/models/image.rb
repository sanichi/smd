Image = Struct.new(:g, :s, :file, :px, :cm, :type, :sold, :name) do
  def src(tn=false)
    "img/gallery%d/%s_%s.jpg" % [g, file, tn ? "100x100" : px]
  end
end
