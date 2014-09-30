require 'open-uri'
class NiagaraPwner
  attr_reader :home_page, :aq, :timestamp_dir, :timestamp, :region_links, :city_offset, :regional_noko
  attr_accessor :regional_inspections_url

  def initialize(acquisition, timestamp = Time.now.to_i)
    @aq = acquisition
    @timestamp = timestamp
    @timestamp_dir = File.join(aq[:path], timestamp.to_s)
    self.ensure_path(timestamp_dir)
    @city = 'cityname'
    @city_noko_query = ['form#infodine_search_form', 'a']
    @regional_noko_query = 'div#global_content>ul.infodine_list_results'
    @href = 'href'
    @link_noko_query = 'a[href]'
    @addy_noko_query = 'span.info_address'
    @name_noko_query = 'span.info_business'
    @date_noko_query = 'span.info_inspection'

  end
  

  def ensure_path(path)
    FileUtils.mkpath(path) unless File.exists?(path)
  end

  def home_page
    Nokogiri::HTML(open(aq[:url]))
  end

  def region_links
    home_page.css(@city_noko_query.first).css(@city_noko_query.last)
  end

   # we need to skip to postion right after 'cityname=' in the url
  def city_offset
    @city.length + 1
  end

  def regional_noko(regional_inspections_url)
    Nokogiri::HTML(open(regional_inspections_url))
  end

  def get_inspection_data

    region_links.map do |a|

      #extract link
      link = a[@href]

      # extract region and translate + to underscore (tr)
      region = link[(link =~ Regexp.new(@city)) + city_offset..link.length].strip.tr('+', '_')
      puts region.colorize(:orange)

      regional_dir = File.join(timestamp_dir, region)
      self.ensure_path(regional_dir)

      regional_inspections_url = File.join(aq[:url], link)

      link = addy = name = date = ''

      regional_noko(regional_inspections_url).css(@regional_noko_query).children.each do |div|

        link = div.css(@link_noko_query).map {|e| e[@href]}[0]
        addy = div.css(@addy_noko_query).text.to_s
        name = div.css(@name_noko_query).text.to_s
        date = div.css(@date_noko_query).text.to_s

        unless link.nil?
          file_name = CGI::escape(name.strip.gsub(' ', '_'))+ '.html'
          destination_file = File.join(regional_dir, file_name)
          url = (aq[:url] + link)

          url = self.strip_chars(url, ['(', ')', 39.chr])

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
  end

  def strip_chars(a_string, char_array = [])
    slash = 92.chr
    single_quote = 39.chr
    double_slash = slash * 2

    char_array.each do |c|
      escape = (c == single_quote ? double_slash : slash)
      a_string = a_string.gsub(c, escape + c)
    end
    a_string
  end
end
