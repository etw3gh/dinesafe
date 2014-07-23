Dinesafe
===

Monitors the City of Toronto dinesafe xml archive for changes.
Compiles all versions into a master archive.
Web scrapes other regions in Ontario without open data inspection formats.

Dinesafe archive grabber
---
https://github.com/openciti/dinesafe/blob/master/config/initializers/dinesafe_scheduler.rb


Dinesafe XML to ActiveRecord parser
---
https://github.com/openciti/dinesafe/blob/master/config/initializers/dinesafe_scraper.rb

Rake Tasks
---
https://github.com/openciti/dinesafe/blob/master/lib/tasks/dinesafe_tasks.rake

Usage
---

    rake dinesafe:grab dinesafe:parse
    rails s
