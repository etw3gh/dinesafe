cron_job = '00 18 * * 1-5'
#           6:00p     m-f

puts 'Starting Cron task. Will check for a new dinesafe archive every weekday at 6pm'.colorize(:green)


Rufus::Scheduler.new.cron cron_job do
  system('rake dinesafe:grab')
end
