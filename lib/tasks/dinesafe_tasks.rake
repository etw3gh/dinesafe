namespace :dinesafe do

  dinesafe = Acquisitions.instance.dinesafe
  shapefiles = Acquisitions.instance.shapefiles

  desc "Tasks to downloads and unzips dinesafe.xml archive"
  task :grab => :environment do

    city_archive_timestamp = Header.new(dinesafe[:url]).last_modified

    Archiver.new(dinesafe).do_and_print

  end

  desc "Reconciles legacy archives with the database"
  task :reconcile => :environment do

  end




  desc "Parses the xml archive and puts it into the database with ActiveRecord"
  task :parse => :environment do
   puts DinesafeScraper.new(dinesafe).parse ? 'Finished parsing dinesafe'.colorize(:green) : 'Dinesafe archived previously parsed or not fresh'.colorize(:red)
  end

  desc "Download the Shapefile from the city of Toronto"
  task :grabshape => :environment do
    Archiver.new(shapefiles).do_and_print
  end

  desc "Populates the Address Model with geo data from a shape file"
  task :geo => :environment do
    puts DinesafeGeo.new(shapefiles).parse ? 'Finished parsing shapefile'.colorize(:green) : 'Shapefile archived previously parsed or not fresh'.colorize(:red)
  end

  desc "Meshes the geo data in the Address model with the Venue model"
  task :mesh => :environment do

  end
end