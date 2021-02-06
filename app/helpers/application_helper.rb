module ApplicationHelper
  PICTURES = [
    [1, 1, "amalfi_coast",                       "600x360", "42x30", "mm", "Amalfi Coast"],
    [1, 1, "a_quiet_street_in_venice",           "421x600", "00x00", "mm", "A Quiet Street in Venice"],
    [1, 1, "midnight_in_florence",               "600x500", "39x33", "mm", "Midnight in Florence"],
    [1, 1, "cotingac_france",                    "400x600", "26x39", "mm", "Cotingac, France"],
    [1, 1, "french_village",                     "400x600", "00x00", "mm", "Provencal Village"],
    [1, 1, "flamboyant_olives",                  "600x600", "30x30", "mm", "Flamboyant Olives"],
    [1, 1, "bargemon_provence",                  "600x400", "42x30", "mm", "Bargemon, Provence"],
    [1, 1, "provencal_village",                  "600x400", "42x29", "mm", "French Village"],
    [1, 1, "amalfi_houses",                      "400x600", "29x42", "mm", "Amalfi Houses"],
    [1, 1, "la_dolce_vita",                      "600x600", "37x39", "mm", "La Dolce Vita"],
    [1, 1, "marias_cafe",                        "400x600", "15x21", "mm", "Maria's Cafe"],
    [1, 1, "secret_of_villa_gioia",              "530x600", "20x20", "mm", "The Secret of Villa Gioia"],
    [1, 1, "lerici_italy",                       "600x500", "56x46", "mm", "Lerici, Italy"],
    [1, 1, "cliff_top_houses_cinque_terre",      "600x414", "00x00", "mm", "Cinque Terre, Village"],
    [1, 1, "provencal_olives",                   "600x450", "00x00", "mm", "Provencal Olives"],
    [1, 1, "st_marks_venice",                    "600x608", "00x00", "mm", "St Mark's Venice"],
    [1, 1, "tonys_olives",                       "600x450", "00x00", "wc", "Tony's Olives"],
    [1, 1, "positano",                           "900x582", "00x00", "mm", "Positano"],
    [1, 1, "washing_day_venice",                 "900x680", "59x48", "mm", "Washing Day, Venice"],
    [1, 1, "a_bit_of_shade",                     "810x600", "38x29", "ol", "A Bit of Shade, Spain"],
    [2, 1, "after_the_rain",                     "600x440", "56x46", "mm", "After the Rain"],
    [2, 1, "across_the_moorfoots",               "600x300", "69x48", "mm", "Across the Moorfoots"],
    [2, 1, "the_moorfoots",                      "600x235", "00x00", "mm", "The Moorfoots"],
    [2, 1, "derbyshire_dales",                   "600x440", "39x27", "mm", "Derbyshire Dales"],
    [2, 1, "into_the_blue_rocky_foreshore",      "600x420", "00x00", "mm", "Into the Blue, Rocky Foreshore"],
    [2, 1, "borderlands",                        "600x400", "58x42", "mm", "Borderlands"],
    [2, 1, "glimpse_of_islands",                 "600x400", "42x33", "mm", "A Glimpse of Islands"],
    [2, 1, "the_sentinel",                       "600x500", "35x33", "mm", "The Sentinel"],
    [2, 1, "shades_of_iona",                     "600x500", "41x23", "mm", "Shades of Iona"],
    [2, 1, "take_me_there",                      "600x445", "42x29", "mm", "Take Me There"],
    [2, 1, "the_sea_sets_you_free",              "600x450", "00x00", "mm", "The Sea Sets You Free"],
    [2, 0, "eigg_and_rum",                       "744x600", "00x00", "mm", "Eigg and Rum"],
    [2, 1, "gathering_clouds_at_beadnell_bay",   "600x433", "00x00", "mm", "Gathering Clouds at Beadnell Bay"],
    [2, 0, "gathering_storm_east_lothian",       "600x408", "00x00", "mm", "Gathering Storm, East Lothian"],
    [2, 0, "poppy_field_east_lothian",           "800x548", "00x00", "mm", "Poppy Field, East Lothian"],
    [2, 0, "poppy_field_fife",                   "800x500", "00x00", "mm", "Poppy Field, Fife"],
    [2, 1, "the_singing_sands",                  "800x800", "00x00", "mm", "The Singing Sands"],
    [2, 1, "north_berwick_law",                  "800x520", "00x00", "mm", "North Berwick Law"],
    [2, 0, "hopeman_beach",                      "600x441", "00x00", "mm", "Hopeman Beach"],
    [2, 1, "pink_socks_stockbridge",             "600x581", "00x00", "mm", "Pink Socks, Stockbridge"],
    [2, 0, "red_chimneys_arisaig",               "600x261", "00x00", "mm", "Red Chimneys Arisaig"],
    [2, 0, "salisbury_crags_edinburgh",          "600x450", "00x00", "mm", "Salisbury Crags, Edinburgh"],
    [2, 0, "storms_approaching_in_beadnell_bay", "600x423", "00x00", "mm", "Storms Approaching in Beadnell Bay"],
    [2, 1, "rocky_foreshore",                    "800x400", "00x00", "mm", "Rocky Foreshore"],
    [2, 0, "dark_trees",                         "800x550", "00x00", "mm", "Dark Trees"],
    [3, 0, "blue_hydrangeas",                    "600x567", "00x00", "mm", "Blue Hydrangeas"],
    [3, 0, "chunky_chick",                       "600x600", "00x00", "wc", "Chunky Chick"],
    [3, 0, "three_french_hens",                  "600x388", "00x00", "wc", "Three French Hens"],
    [3, 0, "roses_in_bloom",                     "600x561", "00x00", "wc", "Roses in Bloom"],
    [3, 1, "summer_flowers",                     "600x561", "00x00", "wc", "Summer Flowers"],
    [3, 1, "warm_breeze",                        "600x433", "00x00", "mm", "Warm Breeze"],
    [4, 0, "lake",                               "450x600", "00x00", "pt", "Lake"],
    [4, 0, "standing_figure",                    "230x600", "00x00", "pt", "Standing Figure"],
    [4, 0, "topaz",                              "450x600", "00x00", "cc", "Gathering Clouds at Beadnell Bay"],
    [4, 0, "topaz_profile",                      "436x600", "00x00", "cc", "Topaz Profile"],
  # [1, 1, "olive_trees_provence",               "900x560", "00x00", "mm", "Olive Trees, Provence"],
  # [1, 0, "cinque_terre",                       "600x809", "00x00", "mm", "Cinque Terre"],
  # [1, 0, "italian_steps",                      "600x867", "00x00", "mm", "Italian Steps"],
  # [2, 0, "a_patch_of_light_the_meadows",       "732x600", "00x00", "ol", "A Patch of Light, The Meadows"],
  # [2, 0, "across_the_moors",                   "600x645", "00x00", "ol", "Across the Moors"],
  # [2, 0, "golden_glow_skye",                   "889x600", "00x00", "mm", "Golden Glow, Skye"],
  # [2, 0, "pleasures_are_like_poppies_spread",  "800x600", "00x00", "mm", "Pleasures Are Like Poppies Spread"],
  # [2, 1, "staffin_bay_skye",                   "600x345", "00x00", "mm", "Staffin Bay Skye"],
  ].map { |d| Image.new(*d) }

  def pictures(gallery)
    pics = PICTURES.select{ |p| p.g == gallery }

    trys = [4, 5, 6]
    if pics.empty?
      cols = trys[-1]
    elsif pics.length <= trys[-1]
      cols = pics.length
    else
      scores = trys.map { |t| pics.length % t }
      exact = scores.rindex(0)
      if exact
        cols = trys[exact]
      else
        cols = trys[scores.rindex(scores.max)]
      end
    end

    [pics, cols]
  end

  def sample_work
    PICTURES.select{ |p| p.s == 1 }.sample.src
  end
end
