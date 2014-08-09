require 'open-uri'
class NiagaraPwner
  attr_reader :aq, :timestamp, :timestamp_dir, :wget

  def initialize(acquisition, ts = Time.now.to_i.to_s)
    @aq = acquisition
    @timestamp = ts.to_s
    @timestamp_dir = File.join(aq[:path], ts.to_s)
    self.ensure_path(timestamp_dir)
    @wget = "wget -O "
  end

  def ensure_path(path)
    FileUtils.mkpath(path) unless File.exists?(path)
  end

  def get_inspection_data
    home_page = Nokogiri::HTML(open(aq[:url]))
    region_links = home_page.css('form#infodine_search_form').css('a')

    city = 'cityname'

    # skip to postion right after cityname= in the url
    city_offset = city.length + 1

    region_links.map do |a|

      #extract link
      link = a['href']

      # extract region and translate + to underscore (tr)
      region = link[(link =~ Regexp.new(city)) + city_offset..link.length].strip.tr('+', '_')
      puts region.colorize(:orange)

      regional_dir = File.join(timestamp_dir, region)
      self.ensure_path(regional_dir)

      regional_inspections_url = File.join(aq[:url], link)
      regional_noko = Nokogiri::HTML(open(regional_inspections_url))

      fails = Array.new
      link = addy = name = date = ''

      for div in regional_noko.css('div#global_content>ul.infodine_list_results').children

        link = div.css('a[href]').map {|e| e['href']}[0]
        addy = div.css('span.info_address').text.to_s
        name = div.css('span.info_business').text.to_s
        date = div.css('span.info_inspection').text.to_s

        unless link.nil?
          file_name = CGI::escape(name.strip.gsub(' ', '_'))+ '.html'
          destination_file = File.join(regional_dir, file_name)
          url = (aq[:url] + link)

          url = self.strip_chars(url, ['(', ')', 39.chr])

          system("#{wget} #{destination_file} #{url}")
          unless $?.exitstatus == 0
            puts "ERROR: #{url}".colorize(:red)
            fails.push(url)
          end
          puts url.colorize(:light_green)
        end
      end
      if fails.count == 0
        puts "OK: #{region}".colorize(:green)
      else
        puts fails
        puts "#{fails.count} errors: ".colorize(:red)
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