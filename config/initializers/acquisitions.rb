# good candidate to seed into an Acquisitions model,

class Acquisitions

  attr_accessor :shapefiles, :dinesafe

  def initialize
    @shapefiles = {url: 'http://opendata.toronto.ca/gcc/address_points_wgs84.zip',
                  path: 'app/assets/shapefiles',
                  shapefile: 'ADDRESS_POINT_WGS84.shp',
                  archive: 'app/assets/shapefiles/archives',
                  category: 'shapefile',
                  region: 'Toronto',
                  subregion: ''}

    @dinesafe = {url: 'http://opendata.toronto.ca/public.health/dinesafe/dinesafe.zip',
                path: 'app/assets/dinesafe',
                dinesafe: 'dinesafe.xml',
                archive: 'app/assets/dinesafe/archives',
                category: 'dinesafe',
                region: 'Toronto',
                subregion: ''}

  end

end