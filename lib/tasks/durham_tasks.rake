namespace :durham do

  durham = Acquisitions.instance.durham

  # WARNING this takes a while, to speed up, minimize other network usage during this task
  # At last count 3181 web pages are saved to the app/assets/dinesafe_durham/#{timestamp} directory
  # DONT BE A DICK: run this task late at night

  desc "Pwns ASPX Inspection websites for every restaurant in the Durham region"
  task :pwn => :environment do
    d = DurhamPwner.new(durham)
    d.mass_wget(d.get_urls(d.inspections))
  end

  desc "Scrapes the pwned inspection sites"
  task :scrape => :environment do
    s = DurhamScraper.new(durham)


  end
end