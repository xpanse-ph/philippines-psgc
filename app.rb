require 'json'
require 'roo'
require 'pp'

# regions = [
#   {
#     "code": "14",
#     "name": "NCR",
#     "type": "region",
#     "provinces": [
#       {
#         "code": "1401",
#         "name": "ABRA",
#         "type": "province",
#         "cities": [
#           {
#             "code": "140101",
#             "name": "BANGUED (Capital",
#             "type": "city"
#           }
#         ]
#       }
#     ]
#   }
# ]

xlsx = Roo::Excelx.new("./psgc-publications/PSGC Publication Jun2018.xlsx")
as = address_sheet = xlsx.sheet('PSGC')
regions = []

(2..as.count).each do |i|
  current_cell  = as.cell(i, 1).to_s

  region        = current_cell[0..1]
  province      = current_cell[2..3]
  city          = current_cell[4..5]
  barangay      = current_cell[6..8]

  # sets up regions
  if region != 13
    unless regions.detect { |r| r[:code] == region }
      regions << { code: region, psgc_code: "#{region}0000000", type: "region" }
    end
  end

  # sets up region names
  if province == "00" && city == "00" && barangay == "000"
    region_hash_missing_name = regions.detect { |r| r[:code] == region }
    region_hash_missing_name[:name] = as.cell(i, 2)
  end

  # provinces (regions hash should exist here)
  # unless ["39", "74", "75", "76", "97", "98"].include?(province)
  unless province == "00"
    current_region_hash = regions.detect { |r| r[:code] == region }
    if current_region_hash[:provinces]
      unless current_region_hash[:provinces].detect { |c| c[:code] == province}
        unless province == "00"
          current_region_hash[:provinces] << { code: province, psgc_code: "#{region}#{province}00000", type: "province" }
        end
      end
    else
      current_region_hash[:provinces] = []
      current_region_hash[:provinces] << { code: province, psgc_code: "#{region}#{province}00000", type: "province" }
    end

    # sets up province names
    if city == "00" && barangay == "000"
      province_hash_missing_name = current_region_hash[:provinces].detect { |c| c[:code] == province}
      province_hash_missing_name[:name] = as.cell(i, 2)
    end

    unless city == "00"
      current_province_hash = current_region_hash[:provinces].detect { |c| c[:code] == province}
      if current_province_hash[:cities]
        unless current_province_hash[:cities].detect { |b| b[:code] == city }
          unless city == "00"
            current_province_hash[:cities] << { code: city, psgc_code: "#{region}#{province}#{city}000", type: "city" }
          end
        end
      else
        current_province_hash[:cities] = []
        current_province_hash[:cities] << { code: city, psgc_code: "#{region}#{province}#{city}000", type: "city" }
      end

      if barangay == "000"
        city_hash_missing_name = current_province_hash[:cities].detect { |b| b[:code] == city }
        city_hash_missing_name[:name] = as.cell(i, 2)
      end
    end
  end
end

list_of_provinces = []
list_of_provinces << { "METRO MANILA": [] }

regions.each do |region|
  region[:provinces].each do |province|
    # Cities that shouldn't be provinces
    if ["97", "98"].include?(province[:code])

    end

    # MM Districts
    if ["39", "74", "75", "76"].include?(province[:code])
      province[:cities].each do |city|
        new_city_name = city[:name].gsub("CITY OF ", "")
        list_of_provinces[0][:"METRO MANILA"] << new_city_name
      end
    end

    unless ["39", "74", "75", "76", "97", "98"].include?(province[:code])
      city_list = []
      province[:cities].each do |city|
        city_list << city[:name]
      end

      if province[:name] == "MAGUINDANAO"
        city_list << "COTABATO CITY"
      elsif province[:name] == "BASILAN"
        city_list << "ISABELA"
      end

      list_of_provinces << { "#{province[:name]}": city_list.sort { |a, b| a <=> b } }
    end
  end
end

File.open("prov-citymuns.json", "wb") { |file| file.puts JSON.pretty_generate(list_of_provinces) }
File.open("prov-citymuns.min.json", "wb") { |file| file.puts list_of_provinces.to_json }

