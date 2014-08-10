Dinesafe
===

Monitors the City of Toronto dinesafe xml archive for changes.
Compiles all versions into a master archive.
Web scrapes other regions in Ontario without open data inspection formats.

Licence
---
Contains information licensed under the Open Government Licence – Toronto.
http://www1.toronto.ca/wps/portal/contentonly?vgnextoid=4a37e03bb8d1e310VgnVCM10000071d60f89RCRD

Acquisitions Singleton
---
App data is contained here until as many regions as possible are covered.
Hopefully, a suitable model will emerge for this to become a singleton model.

https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/acquisitions.rb


Dinesafe (Toronto) Archive grabber
---
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/dinesafe/archiver.rb

ArchiveDirectory class
---
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/dinesafe/archive_directory.rb

Dinesafe (Toronto) XML scraper
---
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/dinesafe/dinesafe_scraper.rb

ShapeFile (Toronto) scraper
---
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/dinesafe/dinesafe_geo.rb

[screencap](https://raw.githubusercontent.com/openciti/dinesafe/master/app/assets/images/dev_screenshots/geo.png)


Dinesafe (Durham)
---
Nicely puts all (approx 3000) inspection links on a single page

pwner:
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/durham_dinesafe/durham_pwner.rb

scraper:
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/durham_dinesafe/durham_scraper.rb


InfoDine - Niagara (12 regions)
---

More involved than Durham region as there are 12 inspection sites instead of one

https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/infodine/niagara_pwner.rb

    - gets the 12 regional urls from the infodine homepage
    - creates a directory structure with a timestamp as the root and
        with a subfolder for each region
    - blasts through each regional site to get inspection urls
    - saves the eventual desired file path and the url in the Grab
        model for later processing
    - TODO start a cron task to perform scraping on the over 3000 inspection urls
    - TODO write the final scraper

Yorksafe - York region
---

Not hard to request all records in one page by setting &page-size=-1

pwner:
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/york/york_pwner.rb

scraper: TODO

Waterloo Region
---
Has open data, in csv and kml formats. Shapefile is corrupted.

grabber:
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/waterloo/waterloo_archiver.rb

Rake Tasks
---
https://github.com/openciti/dinesafe/tree/master/lib/tasks

    dinesafe:grab dinesafe:parse
    dinesafe:grabshapefile dinesafe:geo

    waterloo:grab infodine:pwn durham:pwn york:pwn

