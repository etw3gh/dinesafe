require 'singleton'

class Acquisitions
  include Singleton

  def initialize
    @assets_root = 'lib/assets/'
  end

  # OPEN DATA REGIONS

  #TODO combine shapefiles into toronto
  #toronto
  def shapefiles
    {url: 'http://opendata.toronto.ca/gcc/address_points_wgs84.zip',
     path: "#{@assets_root}dinesafe/shapefiles",
     filename: 'ADDRESS_POINT_WGS84.shp',
     archive: "#{@assets_root}dinesafe/shapefiles/archives",
     category: 'shapefile',
     region: 'Toronto'}
  end

  def dinesafe
    {url: 'http://opendata.toronto.ca/public.health/dinesafe/dinesafe.zip',
     path: "#{@assets_root}dinesafe",
     filename: 'dinesafe.xml',
     archive: "#{@assets_root}dinesafe/archives",
     category: 'dinesafe',
     region: 'Toronto'}
  end

  def waterloo
    {url: 'http://www.regionofwaterloo.ca/en/regionalGovernment/FoodPremiseDataset.asp',
     path: "#{@assets_root}waterloo",
     filename: nil,
     subpaths: {
          :shp =>  'http://www.regionofwaterloo.ca/opendatadownloads/FoodFacilities.zip',
          :kml => 'http://www.regionofwaterloo.ca/opendatadownloads/FoodFacilities_kmz.zip',
          :inspections => 'http://www.regionofwaterloo.ca/opendatadownloads/Inspections.zip'
     },
     category: 'waterloo',
     region: 'Waterloo'}
  end

  def peel

  end

  def ottawa
    {
        url: 'http://app01.ottawa.ca/inspections-opendata/yelp_ottawa_healthscores.zip',
        path: "#{@assets_root}ottawa",
        filename: nil,
        archive: "#{@assets_root}ottawa/archives",
        contents: {
              :businesses => 'businesses.csv',
              :feed_info => 'feed_info.csv',
              :inspections => 'inspections.csv',
              :legend => 'legend.csv',
              :violations => 'violations.csv'
        },
        category: 'ottawa',
        region: 'Ottawa'
    }
  end

  # WEB SCRAPE REGIONS

  def durham
    {url: 'http://www.durham.ca/dineSafe/DineSafeInspectionSearch.aspx',
     path: "#{@assets_root}dinesafe_durham",
     prefix: 'http://www.durham.ca/dineSafe/',    # TODO please standardize this stuff
     archive: "#{@assets_root}dinesafe_durham/archives",
     category: 'durham',
     region: 'Durham'}
  end

  def infodine
    {url: 'http://www.niagararegion.ca/living/health_wellness/inspect/infodine/',
     path: "#{@assets_root}infodine",
     filename: nil,
     archive: "#{@assets_root}infodine/",
     category: 'infodine',
     region: 'Niagara'}
  end

  def halton
    {url: 'http://webaps.halton.ca/health/services/foodsafety/',
     # keep search size at 25000 to get all results
     search_term: 'page1_size25000.aspx',
     path: "#{@assets_root}halton",
     filename: nil,
     category: 'dinewise',
     region: 'Halton'}
  end

  def bc

  end

  # Faciltiy type sites

  def timiskaming
    {path: "#{@assets_root}timiskaming",
     url: 'http://tihu.hedgerowsoftware.com/',
     search_term: 'Facility?alpha=&search-term=&submit-search=&page-size=-1',
     category: '',
     region: 'timiskaming'}
  end

  def guelph
    {path: "#{@assets_root}guelph",
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
     path: "#{@assets_root}york",
     filename: nil,

     category: 'yorksafe',
     region: 'York'}
  end

  # vancouver coastal health
  def van
    {url: 'http://www.inspections.vcha.ca',
     search_term: '/Facility?search-term=&report-type=ffffffff-ffff-ffff-ffff-fffffffffff1&area=&style=&infractions=&sort-by=Name&alpha=&page=0&page-size=-1',
     path: "#{@assets_root}van",
     category: 'van',
     region: 'Vancouver'
    }
  end

end