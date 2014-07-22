scheduler = Rufus::Scheduler.new
scheduler.every '1h' do
  grabber = DinesafeGrabber.new
  grabber.grab
end