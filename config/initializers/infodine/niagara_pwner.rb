require 'open-uri'
class NiagaraPwner
  attr_reader :aq, :timestamp
  attr_accessor :regions, :region_insp_sub_dir

  def initialize(acquisition)
    @aq = acquisition
    @timestamp = Time.now.to_i
    @regions = Hash.new
    self.ensure_dir(aq[:path])
    self.ensure_dir(aq[:archive])
  end

  def get_region_urls
    home_page = Nokogiri::HTML(open(aq[:url]))
    region_links = home_page.css('form#infodine_search_form').css('a')

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

  def ensure_dir(dir)
    Dir.mkdir(dir) unless Dir.exists?(dir)
  end

  def get_regional_html

    timestamped_url_dir = File.join(aq[:archive], timestamp.to_s)
    timestamped_inspections_dir = File.join(aq[:path], timestamp.to_s)
    self.ensure_dir(timestamped_url_dir)
    self.ensure_dir(timestamped_inspections_dir)
    regions.each do |key, value|
      region_insp_sub_dir = File.join(timestamped_inspections_dir, key)

      self.ensure_dir(region_insp_sub_dir)

      file_name = key.strip.gsub(' ', '_') + '.html'

      destination_file = File.join(timestamped_url_dir, file_name)
      puts destination_file.colorize(:green)
      url = aq[:url] + value
      puts url.colorize(:blue)

      system("wget -O #{destination_file} #{url}")

      unless $?.exitstatus == 0
        puts "ERROR: #{url}".colorize(:red)
      end
    end
  end

  def get_inspections(ts = timestamp)
    fails = Array.new
    timestamped_url_dir = File.join(aq[:archive], ts.to_s)
    Dir.entries(timestamped_url_dir).each do |fn|
      region = fn.gsub('_', ' ').split('.html')[0]
      html_file = File.join(timestamped_url_dir, fn)
      #puts html_file.colorize(:green)
      noko = Nokogiri::HTML(open(html_file))

      link = addy = name = date = ''

      for div in noko.css('div#global_content>ul.infodine_list_results').children
        #link = div.css('a[href]').css('href')[0].text.to_s
        link = div.css('a[href]').map {|e| e['href']}[0]
        addy = div.css('span.info_address').text.to_s
        name = div.css('span.info_business').text.to_s
        date = div.css('span.info_inspection').text.to_s

        unless link.nil?
          #puts "#{name} #{addy} #{date}".colorize(:orange)
          #puts link

          timestamped_inspections_dir = File.join(aq[:path], ts.to_s)

          file_name = CGI::escape(name.strip.gsub(' ', '_'))+ '.html'

          destination_file = File.join(timestamped_inspections_dir, region, file_name)

          url = (aq[:url] + link).gsub('(', '\(').gsub(')','\)').gsub(39.chr, 92.chr+92.chr+39.chr)
          #puts destination_file.colorize(:green)
          #puts url.colorize(:blue)

          system("wget -q -O #{destination_file} #{url} ")
          unless $?.exitstatus == 0
            puts "ERROR: #{url}".colorize(:red)
            fails.push(url)
          end
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
end