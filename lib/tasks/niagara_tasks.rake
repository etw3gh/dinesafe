namespace :infodine do

  infodine = Acquisitions.instance.infodine

  desc "pwn the niagara region"
  task :pwn => :environment do
    n = NiagaraPwner.new(infodine)
    n.get_region_urls
    n.get_regional_html
    n.get_inspections
  end

  desc "repwn the inspectins with a hard coded timestamp"
  task :pwni => :environment do
    n = NiagaraPwner.new(infodine, 1407618093)
    n.get_region_urls
    n.get_regional_html
    n.get_inspections
  end

  desc "testing region names"
  task :reg => :environment do
    n = NiagaraPwner.new(infodine)
    puts n.get_region_urls
  end

  desc "parse the pwned sites"
  task :parse => :environment do

  end
end