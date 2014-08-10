class Archiver

  attr_reader :timestamp, :a, :file_name_base, :filename, :timestamped_dir, :archive_fullpath, :headstamp

  # requires an hash defined in Acquisitions
  def initialize(acquisition, headstamp)
    @a = acquisition
    @headstamp = headstamp
    @timestamp = Time.now.to_i.to_s
    self.ensure_dir(@a[:path])
    self.ensure_dir(@a[:archive])
  end

  def ensure_dir(dir)
    Dir.mkdir(dir) unless Dir.exists?(dir)
  end

  def timestamped_dir
    File.join(a[:path], timestamp)
  end

  def file_name_base
    a[:url].split('/').last
  end

  def filename
    timestamp + '_' + file_name_base
  end

  def archive_fullpath
    File.join(a[:archive], filename)
  end

  def grab
    system("wget #{a[:url]} -O #{archive_fullpath}")
    $?.exitstatus == 0 ? true : false
  end

  def verify
    system("unzip -t #{archive_fullpath}")
    $?.exitstatus == 0 ? true : false
  end

  def extract
    self.ensure_dir(timestamped_dir)
    system("unzip #{archive_fullpath} -d #{timestamped_dir}")
    $?.exitstatus == 0 ? true : false
  end

  def persist
    archive_time_stamp = timestamp.split('_')[0]
    zip_full_path = File.join(a[:archive], file_name_base)

    data_dir = Dir.entries(File.join(a[:path], archive_time_stamp))
    extracted_files = data_dir.count - 2

    archive = Archive.where( :timestamp => archive_time_stamp,
                             :zip => zip_full_path,
                             :data => data_dir,
                             :filecount => extracted_files,
                             :region => a[:region],
                             :category => a[:category],
                             :headstamp => headstamp).first_or_create

    puts "Archive result: #{archive.timestamp}, #{archive.zip}" unless archive.nil?
  end

  def print_setup
    f = file_name_base
    fb = f.colorize(:blue)
    fr = f.colorize(:red)

    return f, fb, fr
  end

end
