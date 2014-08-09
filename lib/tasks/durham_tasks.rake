namespace :durham do

  durham = Acquisitions.instance.durham

  desc "Pwns ASPX Inspection websites for every restaurant in the Durham region"
  task :pwn => :environment do
    d = DurhamPwner.new(durham)
    d.mass_wget(d.get_urls(d.inspections))
  end

  desc "Scrapes the inspection sites"
  task :scrape => :environment do
    
  end
end