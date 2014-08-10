require 'singleton'

class Acquisitions
  include Singleton

  # OPEN DATA REGIONS

  #TODO combine shapefiles into toronto
  #toronto
  def shapefiles
    {url: 'http://opendata.toronto.ca/gcc/address_points_wgs84.zip',
     path: 'app/assets/shapefiles',
     filename: 'ADDRESS_POINT_WGS84.shp',
     archive: 'app/assets/shapefiles/archives',
     category: 'shapefile',
     region: 'Toronto'}
  end

  def dinesafe
    {url: 'http://opendata.toronto.ca/public.health/dinesafe/dinesafe.zip',
     path: 'app/assets/dinesafe',
     filename: 'dinesafe.xml',
     archive: 'app/assets/dinesafe/archives',
     category: 'dinesafe',
     region: 'Toronto'}
  end

  def waterloo
    {url: 'http://www.regionofwaterloo.ca/en/regionalGovernment/FoodPremiseDataset.asp',
     path: 'lib/assets/waterloo',
     filename: nil,
     subpaths: {:shp =>  'http://www.regionofwaterloo.ca/opendatadownloads/FoodFacilities.zip',
                :kml => 'http://www.regionofwaterloo.ca/opendatadownloads/FoodFacilities_kmz.zip',
                :inspections => 'http://www.regionofwaterloo.ca/opendatadownloads/Inspections.zip'},
     category: 'waterloo',
     region: 'Waterloo'}
  end

  # WEB SCRAPE REGIONS

  def durham
    {url: 'http://www.durham.ca/dineSafe/DineSafeInspectionSearch.aspx',
     path: 'lib/assets/dinesafe_durham',
     prefix: 'http://www.durham.ca/dineSafe/',    # TODO please standardize this stuff
     archive: 'lib/assets/dinesafe_durham/archives',
     category: 'durham',
     region: 'Durham'}
  end

  def infodine
    {url: 'http://www.niagararegion.ca/living/health_wellness/inspect/infodine/',
     path: 'lib/assets/infodine',
     filename: nil,
     archive: 'lib/assets/infodine/',
     category: 'infodine',
     region: 'Niagara'}
  end

  def halton
    {url: 'http://webaps.halton.ca/health/services/foodsafety/',
     # keep search size at 25000 to get all results
     search_term: 'page1_size25000.aspx',
     path: 'app/assets/halton',
     filename: nil,
     category: 'dinewise',
     region: 'Halton'}
  end

  def bc
    
  end

  # Faciltiy type sites

  def timiskaming
    {url: 'http://tihu.hedgerowsoftware.com/Facility?alpha=&search-term=&submit-search=&page-size=-1'}
  end

  def guelph
    {path: 'lib/assets/guelph',
     url: 'http://www.checkbeforeyouchoose.ca',
     # keep search size at -1 to get all results
     search_term: '/Facility?search-term=&report-type=ffffffff-ffff-ffff-ffff-fffffffffff1&area=&style=&infractions=&sort-by=Name&alpha=&page=0&page-size=-1',
     category: 'checkbeforeyouchoose',
     region: 'Guelph'}
  end

  def york
    {url: 'http://disclosure.york.ca',
     # keep search size at -1 to get all results
     search_term: '/Facility?search-term=&report-type=ffffffff-ffff-ffff-ffff-fffffffffff1&area=&style=&infractions=&sort-by=Name&alpha=&page=0&page-size=-1',
     path: 'lib/assets/york',
     filename: nil,
     category: 'yorksafe',
     region: 'York'}
  end

  # vancouver coastal health
  def van

  end

end