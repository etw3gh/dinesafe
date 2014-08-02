# each archive is timestamped and extracted into a directory 
# bearing the name of the timestamp

# todo do not extract or even keep redundant archives
# todo rake task to purge redundant archives

=begin
├── 1406843156
│   └── dinesafe.xml
├── 1406886676
│   └── dinesafe.xml
├── 1406914477
│   └── dinesafe.xml
├── 1406929874
│   └── dinesafe.xml
└── archives
    ├── 1406231317_dinesafe.zip
    ├── 1406274485_dinesafe.zip
    ├── 1406275506_dinesafe.zip
    ├── 1406276130_dinesafe.zip
    ├── 1406296085_dinesafe.zip
    ├── 1406297107_dinesafe.zip
=end

class ArchiveDirectory
  attr_reader :aq, :archive_file, :make_path, :extract_timestamp, :improper_file, :get_second_last_file

  def initialize(aq)
    @aq = aq
  end

  def archive_file
    aq[:category].to_sym
  end

  def make_path(middle_portion)
    File.join(aq[:path], middle_portion, aq[archive_file])
  end

  def extract_timestamp(file_name)
    file_name.split('_')[0].to_i
  end

  def improper_file(fn)
    fn[0] == '.'
  end

  def get_second_last_file(sorted_array)
    sorted_array[-2].to_s
    end

  # returns a tuple (is_new, timestamp) 
  def is_new
    timestamps = Array.new

    # determine most recent directory by timestamp which is the dir name
    Dir.entries(aq[:archive]).each do |fn|
      timestamps.push(extract_timestamp(fn)) unless improper_file(fn)
    end
    
    sorted = timestamps.sort
    timestamp = sorted.last
    
    most_recent_file = timestamp.to_s
    most_recent_file_path = make_path(most_recent_file)

    if sorted.count >= 2
      second_last_file_path = make_path(get_second_last_file(sorted))

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
