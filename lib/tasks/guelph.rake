require_relative('../app_regional/acquisitions')
require_relative('../app_regional/facility_type_site_pwner')
namespace :guelph do

  guelph = Acquisitions.instance.guelph


  desc "pwn the guelph / wellington 'check before you choose' site"
  task :pwn => :environment do
    g = FacilityTypeSitePwner.new(guelph)

    #stores in grab
    g.get_inspection_links

  end
end