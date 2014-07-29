cron_length_in_hours = 12.to_s
cron_job = cron_length_in_hours + 'h'
puts "Starting Cron task. Will download the dinesafe archive every #{cron_length_in_hours} hours".colorize(:green)

Rufus::Scheduler.new.every cron_job do
  system('rake dinesafe:grab')
end
