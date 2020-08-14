module ApplicationHelper
  PICTURES = [
    {g: 1, top: true,  src: "a_quiet_street_in_venice",           size: "421x600", type: "mm", alt: "A Quiet Street in Venice"},
  # {g: 1, top: true,  src: "cinque_terre",                       size: "600x809", type: "mm", alt: "Cinque Terre"},
    {g: 1, top: true,  src: "cliff_top_houses_cinque_terre",      size: "600x414", type: "mm", alt: "Cinque Terre, Village"},
    {g: 1, top: true,  src: "italian_steps",                      size: "600x867", type: "mm", alt: "Italian Steps"},
    {g: 1, top: true,  src: "provencal_olives",                   size: "600x450", type: "mm", alt: "Provencal Olives"},
    {g: 1, top: true,  src: "st_marks_venice",                    size: "600x608", type: "mm", alt: "St Mark's Venice"},
    {g: 1, top: true,  src: "tonys_olives",                       size: "600x450", type: "wc", alt: "Tony's Olives"},
    {g: 2, top: true,  src: "a_bit_of_shade",                     size: "810x600", type: "ol", alt: "A Bit of Shade"},
    {g: 2, top: true,  src: "a_patch_of_light_the_meadows",       size: "732x600", type: "ol", alt: "A Patch of Light, The Meadows"},
    {g: 2, top: true,  src: "across_the_moors",                   size: "600x645", type: "ol", alt: "Across the Moors"},
    {g: 2, top: true,  src: "eigg_and_rum",                       size: "744x600", type: "mm", alt: "Eigg and Rum"},
    {g: 2, top: true,  src: "gathering_clouds_at_beadnell_bay",   size: "600x433", type: "mm", alt: "Gathering Clouds at Beadnell Bay"},
    {g: 2, top: true,  src: "gathering_storm_east_lothian",       size: "600x408", type: "mm", alt: "Gathering Storm, East Lothian"},
    {g: 2, top: true,  src: "golden_glow_skye",                   size: "889x600", type: "mm", alt: "Golden Glow, Skye"},
    {g: 2, top: false, src: "hopeman_beach",                      size: "600x441", type: "mm", alt: "Hopeman Beach"},
    {g: 2, top: false, src: "pink_socks_stockbridge",             size: "600x581", type: "mm", alt: "Pink Socks, Stockbridge"},
  # {g: 2, top: false, src: "pleasures_are_like_poppies_spread",  size: "800x600", type: "mm", alt: "Pleasures Are Like Poppies Spread"},
    {g: 2, top: false, src: "red_chimneys_arisaig",               size: "600x261", type: "mm", alt: "Red Chimneys Arisaig"},
    {g: 2, top: false, src: "salisbury_crags_edinburgh",          size: "600x450", type: "mm", alt: "Salisbury Crags, Edinburgh"},
    {g: 2, top: false, src: "staffin_bay_skye",                   size: "600x345", type: "mm", alt: "Staffin Bay Skye"},
    {g: 2, top: false, src: "storms_approaching_in_beadnell_bay", size: "600x423", type: "mm", alt: "Storms Approaching in Beadnell Bay"},
    {g: 3, top: true,  src: "blue_hydrangeas",                    size: "600x567", type: "mm", alt:"Blue Hydrangeas"},
    {g: 3, top: true,  src: "chunky_chick",                       size: "600x600", type: "wc", alt:"Chunky Chick"},
    {g: 3, top: true,  src: "three_french_hens",                  size: "600x388", type: "wc", alt:"Three French Hens"},
    {g: 3, top: true,  src: "roses_in_bloom",                     size: "600x561", type: "wc", alt:"Roses in Bloom"},
    {g: 3, top: true,  src: "summer_flowers",                     size: "600x561", type: "wc", alt:"Summer Flowers"},
    {g: 3, top: true,  src: "warm_breeze",                        size: "600x433", type: "mm", alt:"Warm Breeze"},
    {g: 4, top: true,  src: "lake",                               size: "450x600", type: "pt", alt: "Lake"},
    {g: 4, top: true,  src: "standing_figure",                    size: "230x600", type: "pt", alt: "Standing Figure"},
    {g: 4, top: true,  src: "topaz",                              size: "450x600", type: "cc", alt: "Gathering Clouds at Beadnell Bay"},
    {g: 4, top: true,  src: "topaz_profile",                      size: "436x600", type: "cc", alt: "Topaz Profile"},
  ]

  def pictures(g, top)
    PICTURES.select { |p| p[:g] == g && p[:top] == top }
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
