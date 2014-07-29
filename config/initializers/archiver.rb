class Archiver

  attr_reader :timestamp, :timestamped_dir, :archive_fullpath, :a, :file_name_base

  # requires an hash defined in Acquisitions
  def initialize(acquisition)

    @a = acquisition

    # directories will be named after this timestamp
    # zip archives will be prepened with timestamp_
    @timestamp = Time.now.to_i.to_s

    @timestamped_dir = File.join(@a[:path], @timestamp)

    # takes whatever comes after the last / in the url, this should be the filename
    @file_name_base = @a[:url].split('/').last

    @filename = @timestamp + '_' + @file_name_base
    @archive_fullpath = File.join(@a[:archive], @filename)

    # ensure the asset directory (file_home) exists
    Dir.mkdir(@a[:path]) unless Dir.exists?(@a[:path])

    # ensure the archive directory (archive_home) exists
    Dir.mkdir(@a[:archive]) unless Dir.exists?(@a[:archive])
  end

  def grab
    # ensure timestamped directory exists
    Dir.mkdir(@timestamped_dir) unless Dir.exists?(@timestamped_dir)
    system("wget #{@a[:url]} -O #{@archive_fullpath}")
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
    Dir.entries(@a[:archive]).each do |f|

      n = 0
      # exclude "." and ".."
      unless f[0] == '.'

        previous_f = f

        archive_time_stamp = f.split('_')[0]

        data_dir = Dir.entries(File.join(@a[:path], archive_time_stamp))
        extracted_files = data_dir.count - 2

        zip_full_path = File.join(@a[:archive], f)

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
