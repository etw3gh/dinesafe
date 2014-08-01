class ArchiveDirectory
  attr_accessor :aq

  def initialize(aq)
    @aq = aq
  end

  def archive_file
    aq[:category].to_sym
  end

  def make_path(p)
    File.join(aq[:path], p, aq[archive_file])
  end

  def extract_timestamp(file_name)
    file_name.split('_')[0].to_i
  end

  def improper_file(d)
    d[0] == '.'
  end

  # returns a tuple (is_new, timestamp) 
  def is_new
    timestamps = Array.new

    # determine most recent directory by timestamp which is the dir name
    Dir.entries(aq[:archive]).each do |d|
      timestamps.push(extract_timestamp(d)) unless improper_file(d)
    end
    
    sorted = timestamps.sort
    timestamp = sorted.last
    
    most_recent_file = timestamp.to_s
    most_recent_file_path = make_path(most_recent_file)

    if sorted.count >= 2
      second_last_file = sorted[-2].to_s
      second_last_file_path = make_path(second_last_file)

      diff = Diffy::Diff.new(second_last_file_path, most_recent_file_path, :source => 'files').diff
      if diff.nil? || diff.empty?
        return false, timestamp   # timestamp is ignored, but should be second last stamp just in case it will be of use
      else
        return true, timestamp
      end

    else
      return true, timestamp
    end
  end
end
