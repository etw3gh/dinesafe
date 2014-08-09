namespace :infodine do

  infodine = Acquisitions.instance.infodine

  desc "pwn the niagara region"
  task :pwn => :environment do
    n = NiagaraPwner.new(infodine)
    n.get_region_urls
    n.get_regional_html
    n.get_inspections(n.timestamp)
  end

  desc "pwn the inspectins with a hard coded timestamp"
  task :pwni => :environment do
    n = NiagaraPwner.new(infodine)
    n.get_inspections(1407571788)
  end

  desc "parse the pwned sites"
  task :parse => :environment do

  end
end