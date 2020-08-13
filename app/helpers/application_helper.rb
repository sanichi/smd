module ApplicationHelper
  def center(xs: 0, sm: 0, md: 0, lg: 0, xl: 0)
    klass = []
    klass.push "offset-#{(12 - xs) / 2} col-#{xs}" if xs > 0
    klass.push "offset-sm-#{(12 - sm) / 2} col-sm-#{sm}" if sm > 0
    klass.push "offset-md-#{(12 - md) / 2} col-md-#{md}" if md > 0
    klass.push "offset-lg-#{(12 - lg) / 2} col-lg-#{lg}" if lg > 0
    klass.push "offset-xl-#{(12 - xl) / 2} col-xl-#{xl}" if xl > 0
    klass.any? ? klass.join(" ") : "col-12"
  end

  def sample_work
    file = [
      "1/a_quiet_street_in_venice_421x600.jpg",
      "1/cinque_terre_600x809.jpg",
      "1/cliff_top_houses_cinque_terre_600x414.jpg",
      "1/provencal_olives_600x450.jpg",
      "1/st_marks_venice_600x608.jpg",
      "1/tonys_olives_600x450.jpg",
      "2/gathering_clouds_at_beadnell_bay_600x433.jpg",
      "2/pink_socks_stockbridge_600x581.jpg",
      "2/staffin_bay_skye_600x345.jpg",
      "3/summer_flowers_600x561.jpg",
      "3/warm_breeze_600x433.jpg",
    ].sample
    "img/gallery" + file
  end
end
