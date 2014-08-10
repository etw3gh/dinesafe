Dinesafe
===

A dinesafe application covering as much of Ontario as possible.
Twitter: @mydinesafe will serve data by interactive tweet
https://twitter.com/mydinesafe
Web: TODO
Android: TODO

Monitors open data from Peel, Waterloo and Toronto.
Compiles all versions into a master archive.

Collects inspection urls from other regions in Ontario without
open data inspection formats and stores them the Grab model.

URLs in the Grab model are then scraped and serialized.

Licences
---
Contains information licensed under the Open Government Licence – Toronto.
http://www1.toronto.ca/wps/portal/contentonly?vgnextoid=4a37e03bb8d1e310VgnVCM10000071d60f89RCRD

Contains information provided by the Regional Municipality of Waterloo under licence
http://www.regionofwaterloo.ca/en/regionalGovernment/OpenDataLicence.asp.

Acquisitions Singleton
---
App data is contained here until as many regions as possible are covered.
Hopefully, a suitable model will emerge for this to become a singleton model.

https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/ontario/acquisitions.rb


Dinesafe (Toronto) Archive grabber
---
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/ontario/dinesafe/archiver.rb

ArchiveDirectory class
---
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/ontario/dinesafe/archive_directory.rb

Dinesafe (Toronto) XML scraper
---
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/ontario/dinesafe/dinesafe_scraper.rb

ShapeFile (Toronto) scraper
---
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/ontario/dinesafe/dinesafe_geo.rb

[screencap](https://raw.githubusercontent.com/openciti/dinesafe/master/app/assets/ontario/images/dev_screenshots/geo.png)


Dinesafe (Durham)
---
Nicely puts all (approx 3000) inspection links on a single page

pwner:
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/ontario/durham_dinesafe/durham_pwner.rb

scraper:
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/ontario/durham_dinesafe/durham_scraper.rb

Guelph / Wellington
---

Now this is cute. They've decided to call their restaurant inspection model "Check Before You Choose".
Something they should have done before choosing that name.

Same scheme as York region, code was simply copied.

TODO: general class to cover these type of websites.


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
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/ontario/york/york_pwner.rb

scraper: TODO

Waterloo Region
---
Has open data, in csv and kml formats. Shapefile is corrupted.

grabber:
https://github.com/openciti/dinesafe/blob/master/config/initializers/app_regional/ontario/waterloo/waterloo_archiver.rb


Vancouver Coastal Health
---
Good news, same setup as York region!

http://www.inspections.vcha.ca/Facility?search-term=&report-type=ffffffff-ffff-ffff-ffff-fffffffffff1&area=&style=&infractions=&sort-by=Name&alpha=&page=0&page-size=-1



Rake Tasks
---
https://github.com/openciti/dinesafe/tree/master/lib/tasks

    dinesafe:grab dinesafe:parse
    dinesafe:grabshapefile dinesafe:geo

    guelph:pwn durham:pwn infodine:pwn niagara:pwn york:pwn waterloo:grab

