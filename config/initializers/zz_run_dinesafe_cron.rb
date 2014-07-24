puts 'Starting Cron task. Will download the dinesafe archive every 6 hours'.colorize(:green)

Rufus::Scheduler.new.every '6h' do
  system('rake dinesafe:grab')
end