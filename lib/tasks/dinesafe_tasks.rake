namespace :dinesafe do
  desc "Tasks to downloads and unzips dinesafe.xml archive"
  task :grab => :environment do
    Archiver.new(Acquisitions.new.dinesafe).do_and_print
  end

  desc "Parses the xml archive and puts it into the database with ActiveRecord"
  task :parse => :environment do
   puts DinesafeScraper.new.parse ? 'Finished parsing'.colorize(:green) : 'Archived previously parsed or not fresh'.colorize(:red)
  end

  desc "Download the Shapefile from the city of Toronto"
  task :grabshape => :environment do
    Archiver.new(Acquisitions.new.shapefiles).do_and_print
  end

  desc "Populates the Address Model with geo data from a shape file"
  task :geo => :environment do
    geo = DinesafeGeo.new
    geo.parse
  end

  desc "Meshes the geo data in the Address model with the Venue model"
  task :mesh => :environment do

  end
end