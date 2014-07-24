class DinesafeGeo

  def parse
    aq = Acquisitions.new.shapefiles
    shapefile_timestamps = Array.new

    # determine most recent directory by timestamp which is the dir name
    Dir.entries(aq[:archive]).each do |d|
      shapefile_timestamps.push(d.split('_')[0].to_i) unless d[0] == '.'
    end

    timestamp = shapefile_timestamps.zip.max[0]
    most_recent_directory = timestamp.to_s
    most_recent_fullpath = File.join(aq[:path], most_recent_directory, aq[:shapefile])

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

        puts n.to_s.colorize(:light_blue) + " #{num} #{street}".colorize(:orange) + " #{name} ".colorize(:yellow) + "#{lat} #{lng}".colorize(:blue)
        n += 1
      end
    end
  end
end