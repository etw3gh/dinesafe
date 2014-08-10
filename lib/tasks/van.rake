require_relative('../app_regional/acquisitions')
require_relative('../app_regional/facility_type_site_pwner')

namespace :van do
  vch = Acquisitions.instance.van

  desc "pwn vancouver coastal health site"
  task :pwn => :environment do
    v = FacilityTypeSitePwner.new(vch)

    #stores in grab
    v.get_inspection_links

  end
end