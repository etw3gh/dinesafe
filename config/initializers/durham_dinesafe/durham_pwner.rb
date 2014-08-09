class DurhamPwner

  attr_reader :aq, :timestamp

  def initialize(acquisition)
    @aq = acquisition
    @timestamp = Time.now.to_i
  end

  def inspections
    agent = Mechanize.new
    query_page = agent.get(aq[:url])
    form = query_page.form("aspnetForm")
    button = form.button
    form.submit(button).links
  end

  def get_urls(links)
    urls = Array.new
    should_contain = "DineSafeInspectionResults"
    links.each do |link|
      if link.href.include? should_contain
        #strip url of all whitespace including \r, \n and \t anywhere in the string
        urls.push(link.href.gsub(/\s+/, ''))
      end
    end
    urls
  end

  def ensure_dir(dir)
    Dir.mkdir(dir) unless Dir.exists?(dir)
  end

  def mass_wget(urls)
    self.ensure_dir(aq[:path])
    destination = File.join(aq[:path], timestamp)
    self.ensure_dir(destination)

    urls.each do |url|
      id = url.split('=').last.strip
      destination_file = File.join(destination, id)
      system("wget #{url} -O #{destination_file}")
      unless $?.exitstatus == 0
        puts "Failed to get #{id}".colorize(:red)
      end
    end

  end


end