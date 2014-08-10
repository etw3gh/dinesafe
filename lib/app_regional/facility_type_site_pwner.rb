require 'open-uri'
class FacilityTypeSitePwner
  attr_reader :aq, :timestamp_dir, :timestamp

  def initialize(acquisition, timestamp = Time.now.to_i)
    @aq = acquisition
    @timestamp = timestamp
    @timestamp_dir = File.join(aq[:path], timestamp.to_s)
    self.ensure_path(timestamp_dir)
  end

  def ensure_path(path)
    FileUtils.mkpath(path) unless File.exists?(path)
  end

  def get_inspection_links

    all_results_url = File.join(aq[:url], aq[:search_term])

    fetch_table = Nokogiri::HTML(open(all_results_url)).css('table>tr>td>a')

    fetch_table.each do |i|

      link = i.attributes['href'].to_s

      filename = link.split('/').last + '.html'
      destination_file = File.join(timestamp_dir, filename)

      url = File.join(aq[:url], link)

      g = Grab.where(:category => aq[:category],
                     :path => destination_file,
                     :url => url,
                     :downloaded => false,
                     :timestamp => timestamp,
                     :scraped => false).first_or_create

      puts g.path.colorize(:green) + ' ' + g.url.colorize(:light_blue)
    end
  end

  
end