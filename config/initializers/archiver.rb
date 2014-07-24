class Archiver

  attr_accessor :url, :timestamp, :file_home, :timestamped_dir, :archive_home, :archive_fullpath, :file_name_base, :a

  # requires an hash defined in Acquisitions
  def initialize(acquisition)

    @a = acquisition

    # complete url including filename
    @url = acquisition[:url]

    # directories will be named after this timestamp
    # zip archives will be prepened with timestamp_
    @timestamp = Time.now.to_i.to_s

    # this is the filepath, usually app/assets/some_path_here
    @file_home = acquisition[:path]

    # this is the filepath for the archive (zips)
    @archive_home = acquisition[:archive]

    @timestamped_dir = File.join(file_home, @timestamp)

    # takes whatever comes after the last / in the url, this should be the filename
    @file_name_base = url.split('/').last

    @filename = @timestamp + '_' + @file_name_base
    #@fullpath = File.join(file_home, @filename)
    @archive_fullpath = File.join(archive_home, @filename)

    # ensure the asset directory (file_home) exists
    Dir.mkdir(file_home) unless Dir.exists?(file_home)

    # ensure the archive directory (archive_home) exists
    Dir.mkdir(archive_home) unless Dir.exists?(archive_home)
  end

  def grab
    # ensure timestamped directory exists
    Dir.mkdir(@timestamped_dir) unless Dir.exists?(@timestamped_dir)
    system("wget #{@url} -O #{@archive_fullpath}")
    $?.exitstatus == 0 ? true : false
  end

  def verify
    system("unzip -t #{@archive_fullpath}")
    $?.exitstatus == 0 ? true : false
  end

  def extract
    system("unzip #{@archive_fullpath} -d #{@timestamped_dir}")
    $?.exitstatus == 0 ? true : false
  end


  def populate
    archives = Array.new
    Dir.entries(@archive_home).each do |f|

      n = 0
      # exclude "." and ".."
      unless f[0] == '.'

        previous_f = f

        archive_time_stamp = f.split('_')[0]

        data_dir = Dir.entries(File.join(@file_home, archive_time_stamp))
        extracted_files = data_dir.count - 2

        zip_full_path = File.join(@archive_home, f)

        # Archive has primary_key set to timestamp

        latest = true
        unless n == 0
          diff = Diffy::Diff.new(previous_f, zip_full_path, :source => 'files').diff

          if diff.nil? || diff.empty?
            latest = false
          else
            latest = true
          end
        end

        archive = Archive.where( :timestamp => archive_time_stamp,
                                 :zip => zip_full_path,
                                 :data => data_dir,
                                 :filecount => extracted_files,
                                 :region => @a[:region],
                                 :subregion =>  @a[:subregion],
                                 :category => @a[:category],
                                 :fresh => latest).first_or_create

        puts "Archive result: #{archive.timestamp}, #{archive.zip}" unless archive.nil?
        n += 1
      end

    end


  end

  def most_recent

  end


  # for convenience and utility - DRY
  def do_and_print
    f = @file_name_base
    fb = f.colorize(:blue)
    fr = f.colorize(:red)

    puts "\nDownloading #{f}............".colorize(:green)

    puts self.grab ? 'Downloaded: '.colorize(:green) + fb : "Failed Download: #{fr}"
    puts self.verify ? 'Verified: '.colorize(:green) + fb : "Failed Verify: #{fr}"
    puts self.extract ? 'Extracted: '.colorize(:green) + fb : "Failed Extraction: #{fr}"
  end

end