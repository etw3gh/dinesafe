class WaterlooArchiver

  attr_reader :aq, :timestamp, :ok
  attr_accessor :paths, :archive_dir

  def initialize(acquisition)
    @aq = acquisition
    @timestamp = Time.now.to_i.to_s
    @paths = Hash.new
  end

  def ok
    '[OK] '.colorize(:light_blue)
  end

  def ensure_path(path)
    FileUtils.mkpath(path) unless File.exists?(path)
  end

  def grab
    tsdir = aq[:path], timestamp
    archive_dir = File.join(tsdir, 'archive')
    self.ensure_path(archive_dir)

    aq[:subpaths].each do |spath, url|
      sub_path = spath.to_s
      puts '-' * 80
      puts sub_path.colorize(:light_green)


      data_path = File.join(tsdir, sub_path)
      self.ensure_path(data_path)

      file_name = url.split('/').last
      destination_file = File.join(archive_dir, file_name)
      system("wget -q -O #{destination_file} #{url}")

      if $?.exitstatus == 0
        puts ok + "Downloaded".colorize(:green)
        system("unzip -t #{destination_file}")
        if $?.exitstatus == 0
          puts ok + "verified".colorize(:green)
          system("unzip #{destination_file} -d #{data_path}")
          if $?.exitstatus == 0
            puts ok + "unzipped".colorize(:green)
          else
            puts 'Error unzipping: '.colorize(:red) + destination_file.colorize(:yellow)
          end
        else
          puts 'Zip file corrupt: '.colorize(:red) + destination_file.colorize(:yellow)
        end
      else
        puts 'wget failed: '.colorize(:red) + destination_file.colorize(:yellow)
      end
    end
  end
end