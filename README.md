Dinesafe
===

A dinesafe application covering as much of Ontario as possible.

BC is the next target.

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

Contains public sector Information made available under The Regional Municipality of Peel's Open Data Licence - Version 1.0
http://opendata.peelregion.ca/terms-of-use.aspx

Acquisitions Singleton
---
App data is contained here until as many regions as possible are covered.
TODO put into a model and seed in seeds.db

https://github.com/openciti/dinesafe/blob/master/lib/app_regional/acquisitions.rb


Open Data Regions
===

Its 2014, have you seen my open data?
Apparently only Peel, Toronto and Waterloo know its 2014.
TODO: send smoke signals to other regions

Dinesafe (Toronto)
---
Available as an XML file updated on a Monday morning early each month.
https://github.com/openciti/dinesafe/tree/master/lib/app_regional/ontario/dinesafe

Waterloo Region
---
Has open data, in csv and kml formats. Shapefile is corrupted.

https://github.com/openciti/dinesafe/blob/master/lib/app_regional/ontario/waterloo/waterloo_archiver.rb

Peel Region
---
TODO

Non Open Data Regions
===

Fax? Smoke signals? Memorandum? Carrier pigeon?

How to ask for open data from these places? #sarcasm

Dinesafe (Durham)
---
Nicely puts all (approx 3000) inspection links on a single page when you click on an empty form.

https://github.com/openciti/dinesafe/tree/master/lib/app_regional/ontario/durham_dinesafe


InfoDine - Niagara (12 regions)
---
More involved than Durham region as there are 12 inspection sites instead of one

https://github.com/openciti/dinesafe/blob/master/lib/app_regional/ontario/infodine/niagara_pwner.rb

    - gets the 12 regional urls from the infodine homepage
    - creates a directory structure with a timestamp as the root and
        with a subfolder for each region
    - blasts through each regional site to get inspection urls
    - saves the eventual desired file path and the url in the Grab
        model for later processing
    - TODO start a cron task to perform scraping on the over 3000 inspection urls
    - TODO write the final scraper

Regions Using the same web application
===

Inspections for these regions are very easy to access,
as the urls and web structure are the same or similar.

Not hard to request all records in one page by setting &page-size=-1

TODO: general class to cover these type of websites.

Guelph / Wellington
---

Called "Check Before You Choose":
something they should have done before choosing that name.

https://github.com/openciti/dinesafe/blob/master/lib/app_regional/ontario/guelph/guelph_pwner.rb

Timiskaming
---
TODO (has a slight variation on url)

Yorksafe - York region
---

Exactly the same ad Guelph with a different class name (for now, till a generic is written)

Vancouver Coastal Health (VCH)
---

http://www.inspections.vcha.ca/Facility?search-term=&report-type=ffffffff-ffff-ffff-ffff-fffffffffff1&area=&style=&infractions=&sort-by=Name&alpha=&page=0&page-size=-1

British Columbia (BC)
===

All regions except for VCH use the same web app.



Rake Tasks
---
https://github.com/openciti/dinesafe/tree/master/lib/tasks

    dinesafe:grab dinesafe:parse
    dinesafe:grabshapefile dinesafe:geo

    guelph:pwn durham:pwn infodine:pwn niagara:pwn york:pwn waterloo:grab

