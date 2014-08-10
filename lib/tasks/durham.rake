require_relative('../app_regional/acquisitions')
require_relative('../app_regional/ontario/durham_dinesafe/durham_pwner')
require_relative('../app_regional/ontario/durham_dinesafe/durham_scraper')

namespace :durham do

  durham = Acquisitions.instance.durham

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