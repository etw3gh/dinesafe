class DinesafeGeo

  def grab
    base = 'address_points_wgs84.zip'
    url = 'http://opendata.toronto.ca/gcc/' + base
    shapefile_asset_path = 'app/assets/shapefiles/'
    timestamp = Time.now.to_i.to_s
    filename = timestamp + '_' + base
    fullpath = shapefile_asset_path + filename
    Dir.mkdir(shapefile_asset_path) unless Dir.exists?(shapefile_asset_path)

    timestamped_dir = shapefile_asset_path + timestamp + '/'

    Dir.mkdir(timestamped_dir) unless Dir.exists?(timestamped_dir)
    wget_query = "wget #{url} -O #{fullpath}"

    puts 'Downloading File'.colorize(:light_blue)
    system(wget_query)
    if $?.exitstatus == 0
      system("unzip -t #{fullpath}")
      if $?.exitstatus == 0
        system("unzip #{fullpath} -d #{timestamped_dir}")
        if $?.exitstatus == 0
          puts 'Exraction Completed [OK]'.colorize(:green)
        else
          puts 'Extraction Error'.colorize(:red)
          return false
        end
      else
        puts 'Archive failed integrity test'.colorize(:red)
        return false
      end
      true
    else
      puts 'Error downloading shapefile archive'.colorize(:red)
      false
    end
  end

  def parse

  end
end