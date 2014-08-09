require 'open-uri'
class NiagaraPwner
  attr_reader :aq, :timestamp, :timestamp_dir, :wget
  attr_accessor :regions

  def initialize(acquisition, ts = Time.now.to_i.to_s)
    @aq = acquisition
    @timestamp = ts.to_s
    @regions = Hash.new
    @timestamp_dir = File.join(aq[:path], ts.to_s)
    self.ensure_path(timestamp_dir)
    @wget = "wget -nc -O -q"
  end

  def get_region_urls
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
      # start a nested hash
      regions[region] = Hash.new
      regions[region][:link] = link

      #while we have the region, make the urls and inspections directories for each region
      urls_dir = File.join(timestamp_dir, region, 'urls')
      insp_dir = File.join(timestamp_dir, region, 'inspections')

      self.ensure_path(urls_dir)
      self.ensure_path(insp_dir)

      regions[region][:urls_dir] = urls_dir
      regions[region][:insp_dir] = insp_dir
      puts link.colorize(:green)
    end
    regions
  end

  def ensure_path(path)
    FileUtils.mkpath(path) unless File.exists?(path)
  end

  def get_regional_html
    regions.each do |key, value|
      destination_file = File.join(regions[key][:urls_dir], key + '.html')
      url = File.join(aq[:url], value[:link])

      system("#{wget} #{destination_file} #{url}")

      unless $?.exitstatus == 0
        puts "ERROR: #{url}".colorize(:red)
      end
      puts url.colorize(:blue)
    end
  end

  def get_inspections
    fails = Array.new

    Dir.entries(urls_dir).each do |fn|
      region = fn.split('.html')[0]
      html_file = File.join(regions[region][:urls_dir], fn)
      noko = Nokogiri::HTML(open(html_file))

      link = addy = name = date = ''

      for div in noko.css('div#global_content>ul.infodine_list_results').children

        link = div.css('a[href]').map {|e| e['href']}[0]
        addy = div.css('span.info_address').text.to_s
        name = div.css('span.info_business').text.to_s
        date = div.css('span.info_inspection').text.to_s

        unless link.nil?
          file_name = CGI::escape(name.strip.gsub(' ', '_'))+ '.html'
          destination_file = File.join(regions[region][:insp_dir], file_name)
          url = (aq[:url] + link)

          url = self.strip_chars(url, ['(', ')', 39.chr])

          system("#{wget} #{destination_file} #{url} ")
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