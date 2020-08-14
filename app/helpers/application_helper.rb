module ApplicationHelper
  PICTURES = [
    {g: 1, r: 1, s: 1, src: "a_quiet_street_in_venice",           size: "421x600", type: "mm", alt: "A Quiet Street in Venice"},
  # {g: 1, r: 1, s: 0, src: "cinque_terre",                       size: "600x809", type: "mm", alt: "Cinque Terre"},
    {g: 1, r: 1, s: 1, src: "cliff_top_houses_cinque_terre",      size: "600x414", type: "mm", alt: "Cinque Terre, Village"},
    {g: 1, r: 1, s: 0, src: "italian_steps",                      size: "600x867", type: "mm", alt: "Italian Steps"},
    {g: 1, r: 1, s: 1, src: "provencal_olives",                   size: "600x450", type: "mm", alt: "Provencal Olives"},
    {g: 1, r: 1, s: 1, src: "st_marks_venice",                    size: "600x608", type: "mm", alt: "St Mark's Venice"},
    {g: 1, r: 1, s: 1, src: "tonys_olives",                       size: "600x450", type: "wc", alt: "Tony's Olives"},
    {g: 2, r: 1, s: 0, src: "a_bit_of_shade",                     size: "810x600", type: "ol", alt: "A Bit of Shade"},
    {g: 2, r: 1, s: 0, src: "a_patch_of_light_the_meadows",       size: "732x600", type: "ol", alt: "A Patch of Light, The Meadows"},
    {g: 2, r: 1, s: 0, src: "across_the_moors",                   size: "600x645", type: "ol", alt: "Across the Moors"},
    {g: 2, r: 1, s: 0, src: "eigg_and_rum",                       size: "744x600", type: "mm", alt: "Eigg and Rum"},
    {g: 2, r: 1, s: 1, src: "gathering_clouds_at_beadnell_bay",   size: "600x433", type: "mm", alt: "Gathering Clouds at Beadnell Bay"},
    {g: 2, r: 1, s: 0, src: "gathering_storm_east_lothian",       size: "600x408", type: "mm", alt: "Gathering Storm, East Lothian"},
    {g: 2, r: 1, s: 0, src: "golden_glow_skye",                   size: "889x600", type: "mm", alt: "Golden Glow, Skye"},
    {g: 2, r: 2, s: 0, src: "hopeman_beach",                      size: "600x441", type: "mm", alt: "Hopeman Beach"},
    {g: 2, r: 2, s: 1, src: "pink_socks_stockbridge",             size: "600x581", type: "mm", alt: "Pink Socks, Stockbridge"},
  # {g: 2, r: 2, s: 0, src: "pleasures_are_like_poppies_spread",  size: "800x600", type: "mm", alt: "Pleasures Are Like Poppies Spread"},
    {g: 2, r: 2, s: 0, src: "red_chimneys_arisaig",               size: "600x261", type: "mm", alt: "Red Chimneys Arisaig"},
    {g: 2, r: 2, s: 0, src: "salisbury_crags_edinburgh",          size: "600x450", type: "mm", alt: "Salisbury Crags, Edinburgh"},
    {g: 2, r: 2, s: 1, src: "staffin_bay_skye",                   size: "600x345", type: "mm", alt: "Staffin Bay Skye"},
    {g: 2, r: 2, s: 0, src: "storms_approaching_in_beadnell_bay", size: "600x423", type: "mm", alt: "Storms Approaching in Beadnell Bay"},
    {g: 3, r: 1, s: 0, src: "blue_hydrangeas",                    size: "600x567", type: "mm", alt: "Blue Hydrangeas"},
    {g: 3, r: 1, s: 0, src: "chunky_chick",                       size: "600x600", type: "wc", alt: "Chunky Chick"},
    {g: 3, r: 1, s: 0, src: "three_french_hens",                  size: "600x388", type: "wc", alt: "Three French Hens"},
    {g: 3, r: 1, s: 0, src: "roses_in_bloom",                     size: "600x561", type: "wc", alt: "Roses in Bloom"},
    {g: 3, r: 1, s: 1, src: "summer_flowers",                     size: "600x561", type: "wc", alt: "Summer Flowers"},
    {g: 3, r: 1, s: 1, src: "warm_breeze",                        size: "600x433", type: "mm", alt: "Warm Breeze"},
    {g: 4, r: 1, s: 0, src: "lake",                               size: "450x600", type: "pt", alt: "Lake"},
    {g: 4, r: 1, s: 0, src: "standing_figure",                    size: "230x600", type: "pt", alt: "Standing Figure"},
    {g: 4, r: 1, s: 0, src: "topaz",                              size: "450x600", type: "cc", alt: "Gathering Clouds at Beadnell Bay"},
    {g: 4, r: 1, s: 0, src: "topaz_profile",                      size: "436x600", type: "cc", alt: "Topaz Profile"},
  ]

  def pictures(gallery, row)
    PICTURES.select { |p| p[:g] == gallery && p[:r] == row }
  end

  def sample_work
    "img/gallery%d/%s_%s.jpg" % PICTURES.select{ |p| p[:s] == 1 }.sample.fetch_values(:g, :src, :size)
  end
end
