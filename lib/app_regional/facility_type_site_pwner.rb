require 'open-uri'


class FacilityTypeSitePwner
  attr_reader :aq, :fetch_table

  def initialize(acquisition, timestamp = Time.now.to_i)
    @aq = acquisition
    @timestamp = timestamp
    @timestamp_dir = File.join(aq[:path], timestamp.to_s)
    @all_results_url = File.join(aq[:url], aq[:search_term])
    @nokogiri_query = 'table>tr>td>a'
    @html_suffix = '.html'
    @attribute = 'href'
    self.ensure_path(@timestamp_dir)
  end

  def ensure_path(path)
    FileUtils.mkpath(path) unless File.exists?(path)
  end

  def fetch_table
    Nokogiri::HTML(open(@all_results_url)).css(@nokogiri_query)
  end

  def get_inspection_links
    fetch_table.each do |i|

      link = i.attributes[@attribute].to_s
      filename = link.split('/').last + @html_suffix
      destination_file = File.join(@timestamp_dir, filename)

      url = File.join(aq[:url], link)

      g = Grab.where(:category => aq[:category],
                     :path => destination_file,
                     :url => url,
                     :downloaded => false,
                     :last_modified => nil,
                     :scraped => false).first_or_create(:timestamp => @timestamp.to_i)

      puts g.path.colorize(:green) + ' ' + g.url.colorize(:light_blue)
    end
  end

  
end