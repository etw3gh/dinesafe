namespace :guelph do

  guelph = Acquisitions.instance.guelph


  desc "pwn the guelph / wellington 'check before you choose' site"
  task :pwn => :environment do
    g = GuelphPwner.new(guelph)

    #stores in grab
    g.get_inspection_links


  end
end