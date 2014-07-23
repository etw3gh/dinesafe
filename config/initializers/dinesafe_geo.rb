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

    timestamp = shapefile_dirs.zip.max[0]
    most_recent_directory = timestamp.to_s
    most_recent_fullpath = File.join(path, most_recent_directory, shapefile)


    # set the shape model up
    s = Shape.where(:timestamp => timestamp, :region => 'Toronto').first_or_create

    # Shapefile reader
    RGeo::Shapefile::Reader.open(most_recent_fullpath) do |file|
      puts "\nFile contains #{file.num_records} records.".colorize(:orange)

      n = 0
      file.each do |record|

        attributes = record.attributes
        #puts attributes
        #puts "  Geometry: #{record.geometry.as_text}"

        lat = attributes['LATITUDE']
        lng = attributes['LONGITUDE']
        num = attributes['ADDRESS']
        street = attributes['LFNAME']
        lonum = attributes['LONUM']
        lonumsuf = attributes['LONUMSUF']
        hinum = attributes['HINUM']
        hinumsuf = attributes['HINUMSUF']
        ward = attributes['WARD_NAME']
        mun = attributes['MUN_NAME']
        dist = attributes['DISTANCE']
        arc = attributes['ARC_SIDE']
        name = attributes['NAME']

        a = Address.where(:shape_id => s.id,
                          :lat => lat.to_f,
                          :lng => lng.to_f,
                          :num => num.to_s,
                          :street => street.to_s,
                          :lonum => lonum.to_s,
                          :lonumsuf => lonumsuf.to_s,
                          :hinum => hinum.to_s,
                          :hinumsuf => hinumsuf.to_s,
                          :ward => ward.to_s,
                          :mun => mun.to_s,
                          :arc => arc.to_s,
                          :dist => dist.to_f,
                          :name => name).first_or_create

        puts n.to_s.colorize(:light_blue) + " #{num} #{street} #{name} ".colorize(:yellow) + "#{lat} #{lng}".colorize(:blue)
        n += 1
      end
    end
  end
end