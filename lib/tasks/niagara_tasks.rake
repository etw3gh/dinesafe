namespace :infodine do

  # aquires quite a few files (3109)
  # D.B.A.D.

  infodine = Acquisitions.instance.infodine

  desc "pwn the niagara region"
  task :pwn => :environment do
    n = NiagaraPwner.new(infodine)
    n.get_inspection_data
  end

  desc "scrape the final inspection urls"
  task :scrape => :environment do

  end
end