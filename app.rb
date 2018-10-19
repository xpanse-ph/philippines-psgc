require 'roo'
require 'pp'

regions = [
  {
    "code": "14",
    "name": "NCR",
    "type": "region",
    "provinces": [
      {
        "code": "1401",
        "name": "ABRA",
        "type": "province",
        "cities": [
          {
            "code": "140101",
            "name": "BANGUED (Capital",
            "type": "city"
          }
        ]
      }
    ]
  }
]

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
      regions << { code: region, type: "region" }
    end
  end

  # sets up region names
  if province == "00" && city == "00" && barangay == "000"
    region_hash_missing_name = regions.detect { |r| r[:code] == region }
    region_hash_missing_name[:name] = as.cell(i, 2)
  end

  # provinces (regions hash should exist here)
  unless province == "00"
    current_region_hash = regions.detect { |r| r[:code] == region }
    if current_region_hash[:provinces]
      unless current_region_hash[:provinces].detect { |c| c[:code] == province}
        unless province == "00"
          current_region_hash[:provinces] << { code: province, type: "province" }
        end
      end
    else
      current_region_hash[:provinces] = []
      current_region_hash[:provinces] << { code: province, type: "province" }
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
            current_province_hash[:cities] << { code: city, type: "city" }
          end
        end
      else
        current_province_hash[:cities] = []
        current_province_hash[:cities] << { code: city, type: "city" }
      end

      if barangay == "000"
        city_hash_missing_name = current_province_hash[:cities].detect { |b| b[:code] == city }
        city_hash_missing_name[:name] = as.cell(i, 2)
      end
    end
  end
end

province_count  = 0
city_count      = 0

regions.each do |region|
  province_count += region[:provinces].count

  region[:provinces].each do |province|
    puts province[:name]
    city_count += province[:cities].count
  end
end

puts "Regions: #{regions.count}"
puts "Provinces: #{province_count}"
puts "Cities/Municipalities: #{city_count}"




