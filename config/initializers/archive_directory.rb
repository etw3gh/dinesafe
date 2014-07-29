=begin

=end


# rows start at 1

# The Inspection model is being kept while the Venue & Event models are being tested over a longer term

class ArchiveDirectory
  attr_accessor :aq

  def initialize(aq)
    @aq = aq
  end

  def is_new
    timestamps = Array.new

    # determine most recent directory by timestamp which is the dir name
    Dir.entries(@aq[:archive]).each do |d|
      timestamps.push(d.split('_')[0].to_i) unless d[0] == '.'
    end

    sorted = timestamps.sort
    if sorted.count >= 2

      archive_file = @aq[:category].to_sym

      most_recent_file = sorted[-1].to_s
      most_recent_file_path = File.join(aq[:path], most_recent_file, @aq[archive_file])

      second_last_file = sorted[-2].to_s
      second_last_file_path = File.join(aq[:path], second_last_file, @aq[archive_file])

      diff = Diffy::Diff.new(second_last_file_path, most_recent_file_path, :source => 'files').diff
      if diff.nil? || diff.empty?
        return false
      else
        return true
      end

    else
      return true
    end
  end
end
