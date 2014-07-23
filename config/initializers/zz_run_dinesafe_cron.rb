scheduler = Rufus::Scheduler.new
scheduler.every '6h' do
  grabber = DinesafeGrabber.new
  grabber.grab
end