require 'open-uri'
class NiagaraPwner
  attr_reader :aq, :timestamp

  def initialize(acquisition)
    @aq = acquisition
    @timestamp = Time.now.to_i
  end

  def get_region_urls
    home_page = Nokogiri::HTML(open(aq[:url]))
    region_links = home_page.css('form#infodine_search_form').css('a')

    regions = Hash.new

    city = 'cityname'

    # skip to postion right after cityname= in the url
    city_offset = city.length + 1

    region_links.map do |a|

      # extract link
      link = a['href']

      # extract region and translate + to space (tr)
      region = link[(link =~ Regexp.new(city)) + city_offset..link.length].tr('+', ' ')
      # store in hash
      regions[region] = link
    end
    regions
  end

  def get_regional_html

  end

end