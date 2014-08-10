require 'singleton'

class Acquisitions
  include Singleton

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

  def durham
    {url: 'http://www.durham.ca/dineSafe/DineSafeInspectionSearch.aspx',
     path: 'app/assets/dinesafe_durham',
     prefix: 'http://www.durham.ca/dineSafe/',    # TODO please standardize this stuff
     archive: 'app/assets/dinesafe_durham/archives',
     category: 'durham',
     region: 'Durham'}
  end

  def infodine
    {url: 'http://www.niagararegion.ca/living/health_wellness/inspect/infodine/',
     path: 'app/assets/infodine',
     filename: nil,
     archive: 'app/assets/infodine/',
     category: 'infodine',
     region: 'Niagara'}
  end

  def waterloo
    {url: 'http://www.regionofwaterloo.ca/en/regionalGovernment/FoodPremiseDataset.asp',
     path: 'app/assets/waterloo',
     filename: nil,
     subpaths: {:shp =>  'http://www.regionofwaterloo.ca/opendatadownloads/FoodFacilities.zip',
                :kml => 'http://www.regionofwaterloo.ca/opendatadownloads/FoodFacilities_kmz.zip',
                :inspections => 'http://www.regionofwaterloo.ca/opendatadownloads/Inspections.zip'},
     category: 'waterloo',
     region: 'Waterloo'}
  end

  def guelph
      {path: 'app/assets/guelph',
      url: 'http://www.checkbeforeyouchoose.ca',
      # keep search size at -1 to get all results
      search_term: '/Facility?search-term=&report-type=ffffffff-ffff-ffff-ffff-fffffffffff1&area=&style=&infractions=&sort-by=Name&alpha=&page=0&page-size=-1',
      category: 'checkbeforeyouchoose',
      region: 'Durham'}
  end

  def york
    {url: 'http://disclosure.york.ca',
     # keep search size at -1 to get all results
     search_term: '/Facility?search-term=&report-type=ffffffff-ffff-ffff-ffff-fffffffffff1&area=&style=&infractions=&sort-by=Name&alpha=&page=0&page-size=-1',
     path: 'app/assets/york',
     filename: nil,
     category: 'yorksafe',
     region: 'York'}
  end

end