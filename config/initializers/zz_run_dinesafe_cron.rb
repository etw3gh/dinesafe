scheduler = Rufus::Scheduler.new
puts 'Starting Cron task. Will download the dinesafe archive every 6 hours'.colorize(:green)
scheduler.every '6h' do
  grabber = DinesafeGrabber.new
  grabber.grab
end