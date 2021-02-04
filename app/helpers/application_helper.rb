module ApplicationHelper
  PICTURES = [
    [1, 1, "a_quiet_street_in_venice",           "421x600", "mm", "A Quiet Street in Venice"],
    [1, 1, "cliff_top_houses_cinque_terre",      "600x414", "mm", "Cinque Terre, Village"],
    [1, 1, "provencal_olives",                   "600x450", "mm", "Provencal Olives"],
    [1, 1, "st_marks_venice",                    "600x608", "mm", "St Mark's Venice"],
    [1, 1, "tonys_olives",                       "600x450", "wc", "Tony's Olives"],
    [1, 1, "positano",                           "900x582", "mm", "Positano"],
    [1, 1, "olive_trees_provence",               "900x560", "mm", "Olive Trees, Provence"],
    [1, 1, "washing_day_venice",                 "900x680", "mm", "Washing Day, Venice"],
    [2, 0, "after_the_rain",                     "600x440", "mm", "After the Rain"],
    [2, 0, "a_bit_of_shade",                     "810x600", "ol", "A Bit of Shade"],
    [2, 0, "eigg_and_rum",                       "744x600", "mm", "Eigg and Rum"],
    [2, 1, "gathering_clouds_at_beadnell_bay",   "600x433", "mm", "Gathering Clouds at Beadnell Bay"],
    [2, 0, "gathering_storm_east_lothian",       "600x408", "mm", "Gathering Storm, East Lothian"],
    [2, 0, "poppy_field_east_lothian",           "800x548", "mm", "Poppy Field, East Lothian"],
    [2, 0, "poppy_field_fife",                   "800x500", "mm", "Poppy Field, Fife"],
    [2, 1, "the_singing_sands",                  "800x800", "mm", "The Singing Sands"],
    [2, 1, "north_berwick_law",                  "800x520", "mm", "North Berwick Law"],
    [2, 0, "hopeman_beach",                      "600x441", "mm", "Hopeman Beach"],
    [2, 1, "pink_socks_stockbridge",             "600x581", "mm", "Pink Socks, Stockbridge"],
    [2, 0, "red_chimneys_arisaig",               "600x261", "mm", "Red Chimneys Arisaig"],
    [2, 0, "salisbury_crags_edinburgh",          "600x450", "mm", "Salisbury Crags, Edinburgh"],
    [2, 0, "storms_approaching_in_beadnell_bay", "600x423", "mm", "Storms Approaching in Beadnell Bay"],
    [2, 1, "rocky_foreshore",                    "800x400", "mm", "Rocky Foreshore"],
    [2, 0, "dark_trees",                         "800x550", "mm", "Dark Trees"],
    [3, 0, "blue_hydrangeas",                    "600x567", "mm", "Blue Hydrangeas"],
    [3, 0, "chunky_chick",                       "600x600", "wc", "Chunky Chick"],
    [3, 0, "three_french_hens",                  "600x388", "wc", "Three French Hens"],
    [3, 0, "roses_in_bloom",                     "600x561", "wc", "Roses in Bloom"],
    [3, 1, "summer_flowers",                     "600x561", "wc", "Summer Flowers"],
    [3, 1, "warm_breeze",                        "600x433", "mm", "Warm Breeze"],
    [4, 0, "lake",                               "450x600", "pt", "Lake"],
    [4, 0, "standing_figure",                    "230x600", "pt", "Standing Figure"],
    [4, 0, "topaz",                              "450x600", "cc", "Gathering Clouds at Beadnell Bay"],
    [4, 0, "topaz_profile",                      "436x600", "cc", "Topaz Profile"],
  # [1, 0, "cinque_terre",                       "600x809", "mm", "Cinque Terre"],
  # [1, 0, "italian_steps",                      "600x867", "mm", "Italian Steps"],
  # [2, 0, "a_patch_of_light_the_meadows",       "732x600", "ol", "A Patch of Light, The Meadows"],
  # [2, 0, "across_the_moors",                   "600x645", "ol", "Across the Moors"],
  # [2, 0, "golden_glow_skye",                   "889x600", "mm", "Golden Glow, Skye"],
  # [2, 0, "pleasures_are_like_poppies_spread",  "800x600", "mm", "Pleasures Are Like Poppies Spread"],
  # [2, 1, "staffin_bay_skye",                   "600x345", "mm", "Staffin Bay Skye"],
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
