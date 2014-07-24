require 'net/http'

class DinesafeGrabber
  def grab

    dinesafe_zip_url = 'http://opendata.toronto.ca/public.health/dinesafe/dinesafe.zip'
    params = {}

    # affix a timestamp to the filename in order to facilitate keeping old version on file
    timestamp = Time.now.to_i
    filename = timestamp.to_s + '_dinesafe.xml'
    dinesafe_asset_path = 'app/assets/dinesafe'
    fullpath = File.join(dinesafe_asset_path, filename)

    Dir.mkdir(dinesafe_asset_path) unless Dir.exists?(dinesafe_asset_path)

    # output file
    dinesafe_xml = File.open(fullpath, 'w')

    puts 'Dinesafe archive scheduled task...'.colorize(:green)
    puts 'Downloading zip file...'.colorize(:green)

    zip_stream = Net::HTTP.post_form(URI.parse(dinesafe_zip_url), params).body

    Zip::Archive.open_buffer(zip_stream) do |zipfile|
      zipfile.fopen(zipfile.get_name(0)) do |f|
        dinesafe_xml.write(f.read)
      end
    end

    # Archive has primary_key set to timestamp
    latest_query = Archive.last

    if latest_query.nil?
      latest = true
    else
      diff = Diffy::Diff.new(latest_query.fullpath, fullpath, :source => 'files').diff

      if diff.nil? || diff.empty?
        latest = false
      else
        latest = true
      end

    end

    archive = Archive.create(timestamp: timestamp,
                             filename: filename,
                             fullpath: fullpath,
                             region: 'Toronto',
                             subregion: nil,
                             fresh: latest)
    puts "Archive result: #{archive.timestamp}, #{archive.fullpath}" if !archive.nil?


  end
end