require_relative('../app_regional/acquisitions')

# looks like the dinesafe archiver can be reused for this
# TODO put in in another folder that makes more sense
require_relative('../app_regional/ontario/dinesafe/archiver')

require_relative('../app_regional/header')

namespace :ottawa do

  puts "\n-----------------------------------\nOttawa archive grabber\n"

  ottawa = Acquisitions.instance.ottawa

  desc "acquire the zipped inspection data (binary csv)"
  task :grab => :environment do

    #o = OttawaArchiver.new(ottawa).grab

    # copy the pattern used in the dinesafe rake task
    begin
      city_archive_timestamp = Header.new(ottawa[:url]).last_modified.to_i

      # Latest archive has one entry per category type
      latest = LatestArchive.where(:category => ottawa[:category])

      if latest.blank?
        latest_timestamp = 0
      else
        latest_timestamp = latest[0].headstamp.to_i
      end

      puts "City Archive header: ".colorize(:blue) + "#{city_archive_timestamp}".colorize(:light_blue)
      puts "Latest Timestamp: ".colorize(:blue) + "#{latest_timestamp}".colorize(:light_blue)

      if latest.count == 0 || latest_timestamp < city_archive_timestamp
        archiver = Archiver.new(ottawa, city_archive_timestamp)
        f, fb, fr = archiver.print_setup

        puts "\nDownloading #{f}............".colorize(:green)
        puts archiver.grab ? 'Downloaded: '.colorize(:green) + fb : "Failed Download: #{fr}"
        puts archiver.verify ? 'Verified: '.colorize(:green) + fb : "Failed Verify: #{fr}"
        puts archiver.extract ? 'Extracted: '.colorize(:green) + fb : "Failed Extraction: #{fr}"

        archiver.persist

        # update Latest Archive
        la = LatestArchive.where(:category => ottawa[:category])

        # TODO add this to dinesafe rake task in case user is starting from scratch, the current dinesafe:grab will throw an error
        if la.blank?
          #create Latest Archive where none exists
          LatestArchive.where(:category => ottawa[:category],
                              :headstamp => city_archive_timestamp).first_or_create
        else
          # update Latest Archive
          la = LatestArchive.find_by_category(ottawa[:category])
          la.headstamp = city_archive_timestamp
          la.save
        end

        puts "Latest #{ottawa[:category]} Archive stored: #{city_archive_timestamp}"
      else
        puts 'Archive not downloaded. Fresh copy not available'.colorize(:red)
      end
    rescue Faraday::Error::ConnectionFailed
      puts "[ottawa:grab] No Internet Connection was available: ".colorize(:light_red) + DateTime.now.to_s.colorize(:yellow)
    end







  end
end
