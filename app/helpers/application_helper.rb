module ApplicationHelper
  PICTURES = [
    [1, 1, "magical_moonlight_trees",            "810x600", "46x37", "mm", "a", 410, "Magical Moonlight Trees"],
    [1, 1, "moonlight_over_venice",              "900x350", "60x31", "mm", "a", 420, "Moonlight Over Venice"],
    [1, 1, "positano_2",                         "500x700", "48x57", "mm", "s", 430, "Positano 2"],
    [1, 1, "under_the_arches",                   "600x600", "28x28", "mm", "a", 420, "Under the Arches, Venice"],
    [1, 1, "silence_of_villa_gioia",             "600x600", "29x29", "mm", "a", 300, "The Silence of Villa Gioia"],
    [1, 1, "feathered_friends",                  "650x650", "28x28", "mm", "a", 300, "Feathered Friends"],
    [1, 1, "italian_birds",                      "600x400", "27x19", "mm", "s", nil, "Birds of a Feather"],
    [1, 1, "whirling_fluttering",                "500x800", "39x51", "mm", "a", 430, "Whirling and Fluttering"],
    [1, 1, "rio_maggiore",                       "660x660", "34x29", "mm", "a", 340, "Rio Maggiore"],
    [1, 1, "sunny_streets_lerici",               "600x700", "28x28", "mm", "a", 330, "Sunny Streets, Lerici"],
    [1, 1, "amalfi_coast",                       "600x360", "42x30", "mm", "a", nil, "Amalfi Coast"],
    [1, 1, "a_quiet_street_in_venice",           "421x600", "00x00", "mm", "s", nil, "A Quiet Street in Venice"],
    [1, 1, "midnight_in_florence",               "600x500", "39x33", "mm", "a", 550, "Midnight in Florence"],
    [1, 1, "cotingac_france",                    "400x600", "26x39", "mm", "s", nil, "Cotingac, France"],
    [1, 1, "provencal_village",                  "400x600", "00x00", "mm", "s", nil, "Provencal Village"],
    [1, 1, "flamboyant_olives",                  "600x600", "30x30", "mm", "s", nil, "Flamboyant Olives"],
    [1, 1, "bargemon_provence",                  "600x400", "42x30", "mm", "s", 320, "Bargemon, Provence"],
    [1, 1, "french_village",                     "600x400", "42x29", "mm", "a", 250, "French Village"],
    [1, 1, "amalfi_houses",                      "400x600", "29x42", "mm", "a", 320, "Amalfi Houses"],
    [1, 1, "a_day_at_the_beach",                 "700x600", "36x30", "mm", "a", 390, "A Day on the Beach, Lerici"], # used to be la_dolce_vita
    [1, 1, "marias_cafe",                        "400x600", "15x21", "mm", "a", 200, "Maria's Cafe"],
    [1, 1, "secret_of_villa_gioia",              "530x600", "20x20", "mm", "a", 300, "The Secret of Villa Gioia"],
    [1, 1, "lerici_italy",                       "600x500", "56x46", "mm", "s", nil, "Lerici, Italy"],
    [1, 1, "cliff_top_houses_cinque_terre",      "600x414", "00x00", "mm", "s", nil, "Cinque Terre, Village"],
    [1, 1, "provencal_olives",                   "600x450", "00x00", "mm", "s", nil, "Provencal Olives"],
    [1, 1, "st_marks_venice",                    "600x608", "00x00", "mm", "s", nil, "St Mark's Venice"],
    [1, 1, "tonys_olives",                       "600x450", "00x00", "wc", "s", nil, "Tony's Olives"],
    [1, 1, "positano",                           "900x582", "00x00", "mm", "s", nil, "Positano"],
    [1, 1, "washing_day_venice",                 "900x680", "59x48", "mm", "a", 300, "Washing Day, Venice"],
    [2, 1, "spring_forward",                     "500x600", "46x56", "mm", "a", 410, "Spring Forward"],
    [2, 1, "the_company_of_trees",               "600x600", "26x26", "mm", "a", 250, "The Company of Trees"],
    [2, 1, "mediterranean_gardenstown",          "600x600", "43x43", "mm", "a", 420, "Mediterranean Gardenstown"],
    [2, 1, "breathe_in_the_hills",               "580x600", "43x43", "mm", "a", 380, "Breathe in the Hills"],
    [2, 1, "pennan",                             "800x380", "00x00", "mm", "s", nil, "Pennan"],
    [2, 1, "after_the_rain",                     "600x440", "56x46", "mm", "s", nil, "After the Rain"],
    [2, 1, "across_the_moorfoots",               "600x300", "69x48", "mm", "s", 240, "Across the Moorfoots"],
    [2, 1, "the_moorfoots",                      "600x235", "00x00", "mm", "s", nil, "The Moorfoots"],
    [2, 1, "derbyshire_dales",                   "600x440", "39x27", "mm", "a", nil, "Across the Fields"],
    [2, 1, "into_the_blue_rocky_foreshore",      "600x420", "00x00", "mm", "s", 375, "Into the Blue"],
    [2, 1, "borderlands",                        "600x400", "58x42", "mm", "a", 580, "Landlines"],
    [2, 1, "glimpse_of_islands",                 "600x400", "42x33", "mm", "s", 390, "A Glimpse of Islands"],
    [2, 1, "the_sentinel",                       "600x500", "35x33", "mm", "a", 380, "The Sentinel"],
    [2, 1, "shades_of_iona",                     "600x500", "41x23", "mm", "a", 380, "Shades of Iona"],
    [2, 1, "take_me_there",                      "600x445", "42x29", "mm", "a", 380, "Take Me There"],
    [2, 1, "the_sea_sets_you_free",              "600x450", "00x00", "mm", "a", 410, "The Sea Sets You Free"],
    [2, 0, "eigg_and_rum",                       "744x600", "00x00", "mm", "s", nil, "Eigg and Rum"],
    [2, 1, "gathering_clouds_at_beadnell_bay",   "600x433", "00x00", "mm", "s", nil, "Gathering Clouds at Beadnell Bay"],
    [2, 0, "gathering_storm_east_lothian",       "600x408", "00x00", "mm", "s", nil, "Gathering Storm, East Lothian"],
    [2, 0, "poppy_field_east_lothian",           "800x548", "00x00", "mm", "a", 150, "Poppy Field, East Lothian"],
    [2, 0, "poppy_field_fife",                   "800x500", "00x00", "mm", "a", nil, "Poppy Field, Fife"],
    [2, 1, "the_singing_sands",                  "800x800", "00x00", "mm", "s", 250, "The Singing Sands"],
    [2, 1, "north_berwick_law",                  "800x520", "00x00", "mm", "a", nil, "North Berwick Law"],
    [2, 0, "hopeman_beach",                      "600x441", "00x00", "mm", "s", nil, "Hopeman Beach"],
    [2, 1, "pink_socks_stockbridge",             "600x581", "00x00", "mm", "s", nil, "Pink Socks, Stockbridge"],
    [2, 0, "red_chimneys_arisaig",               "600x261", "00x00", "mm", "s", nil, "Red Chimneys Arisaig"],
    [2, 0, "salisbury_crags_edinburgh",          "600x450", "00x00", "mm", "s", nil, "Salisbury Crags, Edinburgh"],
    [2, 0, "storms_approaching_in_beadnell_bay", "600x423", "00x00", "mm", "s", nil, "Storms Approaching in Beadnell Bay"],
    [2, 1, "rocky_foreshore",                    "800x400", "00x00", "mm", "s", nil, "Rocky Foreshore"],
    [2, 0, "dark_trees",                         "800x550", "00x00", "mm", "s", nil, "Dark Trees"],
    [3, 0, "blue_hydrangeas",                    "600x567", "00x00", "mm", "s", nil, "Blue Hydrangeas"],
    [3, 0, "chunky_chick",                       "600x600", "00x00", "wc", "s", nil, "Chunky Chick"],
    [3, 0, "three_french_hens",                  "600x388", "00x00", "wc", "s", nil, "Three French Hens"],
    [3, 0, "roses_in_bloom",                     "600x561", "00x00", "wc", "s", nil, "Roses in Bloom"],
    [3, 1, "summer_flowers",                     "600x561", "00x00", "wc", "s", nil, "Summer Flowers"],
    [3, 1, "warm_breeze",                        "600x433", "00x00", "mm", "s", nil, "Warm Breeze"],
    [4, 0, "lake",                               "450x600", "00x00", "pt", "s", nil, "Lake"],
    [4, 0, "standing_figure",                    "230x600", "00x00", "pt", "s", nil, "Standing Figure"],
    [4, 0, "topaz",                              "450x600", "00x00", "cc", "s", nil, "Topaz"],
    [4, 0, "topaz_profile",                      "436x600", "00x00", "cc", "s", nil, "Topaz Profile"],
  ].map { |d| Image.new(*d) }

  ARCHIVE = [
    [1, 1, "olive_trees_provence",               "900x560", "00x00", "mm", "s", nil, "Olive Trees, Provence"],
    [1, 0, "cinque_terre",                       "600x809", "00x00", "mm", "s", nil, "Cinque Terre"],
    [1, 0, "italian_steps",                      "600x867", "00x00", "mm", "s", nil, "Italian Steps"],
    [1, 1, "forever_venice",                     "900x600", "57x48", "mm", "a", nil, "Forever Venice"],
    [1, 1, "a_bit_of_shade",                     "810x600", "38x29", "ol", "a", nil, "A Bit of Shade, Spain"],
    [2, 0, "a_patch_of_light_the_meadows",       "732x600", "00x00", "ol", "s", nil, "A Patch of Light, The Meadows"],
    [2, 0, "across_the_moors",                   "600x645", "00x00", "ol", "s", nil, "Across the Moors"],
    [2, 0, "golden_glow_skye",                   "889x600", "00x00", "mm", "s", nil, "Golden Glow, Skye"],
    [2, 0, "pleasures_are_like_poppies_spread",  "800x600", "00x00", "mm", "s", nil, "Pleasures Are Like Poppies Spread"],
    [2, 1, "staffin_bay_skye",                   "600x345", "00x00", "mm", "s", nil, "Staffin Bay Skye"],
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

  def search(name)
    return unless name.present?
    PICTURES.find{ |p| p.name == name }
  end

  def selected_number(pics, file)
    return 1 unless file.present?
    1 + (pics.index{ |p| p.file == file } || 0)
  end

  def pagination_links(pager)
    links = Array.new
    links.push(link_to t("pagination.frst"), pager.frst_page, remote: pager.remote, id: "pagn_frst") if pager.after_start?
    links.push(link_to t("pagination.next"), pager.next_page, remote: pager.remote, id: "pagn_next") if pager.before_end?
    links.push(link_to t("pagination.prev"), pager.prev_page, remote: pager.remote, id: "pagn_prev") if pager.after_start?
    links.push(link_to t("pagination.last"), pager.last_page, remote: pager.remote, id: "pagn_last") if pager.before_end?
    raw "#{pager.min_and_max} #{t('pagination.of')} #{pager.count} #{links.size > 0 ? '∙' : ''} #{links.join(t("pagination.sep"))}"
  end

  def center(xs: 0, sm: 0, md: 0, lg: 0, xl: 0, xx: 0)
    klass = []
    klass.push "offset-#{(12 - xs) / 2} col-#{xs}"         if xs > 0
    klass.push "offset-sm-#{(12 - sm) / 2} col-sm-#{sm}"   if sm > 0
    klass.push "offset-md-#{(12 - md) / 2} col-md-#{md}"   if md > 0
    klass.push "offset-lg-#{(12 - lg) / 2} col-lg-#{lg}"   if lg > 0
    klass.push "offset-xl-#{(12 - xl) / 2} col-xl-#{xl}"   if xl > 0
    klass.push "offset-xxl-#{(12 - xx) / 2} col-xxl-#{xx}" if xx > 0
    klass.any? ? klass.join(" ") : "col-12"
  end

  def centre(*args)
    nums = args.map(&:to_i).select{ |n| n > 0 && n < 12 }.sort.reverse
    return "col" if nums.empty?
    nums = nums.first(6) if nums.length > 6
    nums.unshift(12) while nums.length < 6
    cols = %w/xs sm md lg xl xxl/
    0.upto(5).map do |i|
      if nums[i] < 12
        if i == 0
          "col-#{nums[i]}"
        else
          "col-#{cols[i]}-#{nums[i]}"
        end
      else
        nil
      end
    end.compact.join(" ")
  end

  def col(s)
    case s
    when true
      "col-12"
    when false, nil
      ""
    else
      s.to_s.gsub(/(\A| )(sx|ms|dm|gl|lx|lxx)-(\d|1[012])/) do
        "#{$1}offset-#{$2 == 'sx' ? '' : $2.reverse + '-'}#{$3}"
      end.gsub(/(\A| )((?:xs|sm|md|lg|xl|xxl)-)?(\d|1[012])/) do
        "#{$1}col-#{$2 == 'xs-' ? '' : $2}#{$3}"
      end
    end
  end
end
