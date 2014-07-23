class DinesafeGeo

  def grab
    base = 'address_points_wgs84.zip'
    url = 'http://opendata.toronto.ca/gcc/' + base
    shapefile_asset_path = 'app/assets/shapefiles'
    timestamp = Time.now.to_i.to_s
    filename = timestamp + '_' + base
    fullpath = File.join(shapefile_asset_path, filename)

    Dir.mkdir(shapefile_asset_path) unless Dir.exists?(shapefile_asset_path)

    timestamped_dir = File.join(shapefile_asset_path, timestamp)

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
    shapefile = 'ADDRESS_POINT_WGS84.shp'
    path = 'app/assets/shapefiles'
    shapefile_dirs = Array.new

    # determine most recent directory by timestamp which is the dir name
    Dir.entries(path).each do |d|
      puts "#{d} is a directory"  if Dir.exists?(path + d) && d[0] != '.'
      shapefile_dirs.push(d.to_i)
    end

    most_recent_directory = shapefile_dirs.zip.max[0].to_s
    most_recent_fullpath = File.join(path, most_recent_directory, shapefile)

    # Shapefile reader

    RGeo::Shapefile::Reader.open(most_recent_fullpath) do |file|
      puts "File contains #{file.num_records} records."
      file.each do |record|
        puts record.attributes.inspect
        puts '-' * `tput cols`.to_i
      end

    end

  end
end