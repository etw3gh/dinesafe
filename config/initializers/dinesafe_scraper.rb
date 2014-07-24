=begin

  <ROWDATA>
  ...
    <ROW>
      <ROW_ID>904</ROW_ID>
      <ESTABLISHMENT_ID>9001491</ESTABLISHMENT_ID>
      <INSPECTION_ID>102852179</INSPECTION_ID>
      <ESTABLISHMENT_NAME>JAPAN SUSHI</ESTABLISHMENT_NAME>
      <ESTABLISHMENTTYPE>Restaurant</ESTABLISHMENTTYPE>
      <ESTABLISHMENT_ADDRESS>482 BLOOR ST W</ESTABLISHMENT_ADDRESS>
      <ESTABLISHMENT_STATUS>Pass</ESTABLISHMENT_STATUS>
      <MINIMUM_INSPECTIONS_PERYEAR>3</MINIMUM_INSPECTIONS_PERYEAR>
      <INFRACTION_DETAILS/>
      <INSPECTION_DATE>2012-11-02</INSPECTION_DATE>
      <SEVERITY/>
      <ACTION/>
      <COURT_OUTCOME> </COURT_OUTCOME>
      <AMOUNT_FINED> </AMOUNT_FINED>
    </ROW>
  ...
  </ROWDATA>
=end

# rows start at 1

# The Inspection model is being kept while the Venue & Event models are being tested over a longer term

class DinesafeScraper
  attr_accessor :xml_file_path, :timestamp, :fresh

  def initialize
    aq = Acquisitions.new.dinesafe
    dinesafe_timestamps = Array.new
    # determine most recent directory by timestamp which is the dir name
    Dir.entries(aq[:archive]).each do |d|
      dinesafe_timestamps.push(d.split('_')[0].to_i) unless d[0] == '.'
    end

    sorted = dinesafe_timestamps.sort

    @timestamp = sorted[-1]
    most_recent_directory = @timestamp.to_s
    @xml_file_path = File.join(aq[:path], most_recent_directory, aq[:dinesafe])


    if sorted.count >= 2
      second_last = sorted[-2]
      second_last_file = File.join(aq[:path], second_last, aq[:dinesafe])

      diff = Diffy::Diff.new(second_last_file, @xml_file_path, :source => 'files').diff
      if diff.nil? || diff.empty?
        @fresh = false
      else
        @fresh = true
      end

    else
      @fresh = true
    end


  end

  def parse

    return false unless Event.where(:version => @timestamp) == 0
    return false unless @fresh

    # set up Nokogiri

    xml_parser = Nokogiri::XML(File.open(@xml_file_path))

    # splits the xml file into single inspection chunks (see top of file)
    i = xml_parser.css('ROWDATA ROW')

    # counter for output
    n = 0

    i.each_with_index do |row|

      rid =      row.xpath('ROW_ID').text.to_i
      eid =      row.xpath('ESTABLISHMENT_ID').text.to_i
      iid =      row.xpath('INSPECTION_ID').text.to_i
      name =     row.xpath('ESTABLISHMENT_NAME').text.strip.split.join(' ')
      etype =    row.xpath('ESTABLISHMENTTYPE').text.strip.split.join(' ')
      status =   row.xpath('ESTABLISHMENT_STATUS').text.strip.split.join(' ')
      details =  row.xpath('INFRACTION_DETAILS').text.strip.split.join(' ')
      date =     row.xpath('INSPECTION_DATE').text.strip.split.join(' ')
      severity = row.xpath('SEVERITY').text.strip.split.join(' ')
      action =   row.xpath('ACTION').text.strip.split.join(' ')
      outcome =  row.xpath('COURT_OUTCOME').text
      fine =     row.xpath('AMOUNT_FINED').text
      address =  row.xpath('ESTABLISHMENT_ADDRESS').text.strip.split.join(' ')
      mipy =     row.xpath('MINIMUM_INSPECTIONS_PERYEAR').text.to_i
=begin
      begin
        x = Inspection.create(rid:      rid,
                              eid:      eid,
                              iid:      iid,
                              name:     name,
                              etype:    etype,
                              status:   status,
                              details:  details,
                              date:     date,
                              severity: severity,
                              action:   action,
                              outcome:  outcome,
                              fine:     fine,
                              address:  address,
                              mipy:     mipy,
                              version:  @timestamp
        )
        # only print out every 500th venue

      rescue ActiveRecord::RecordNotUnique
        puts "Dupe"
      end
=end
      v = Venue.where(:eid => eid,
                      :name => name,
                      :address => address,
                      :etype => etype,
                      :lat => nil,
                      :lng => nil,
                      :mipy => mipy).first_or_create

      i = Event.where(:iid => iid,
                      :venue_id => v.id,
                      :status => status,
                      :details => details,
                      :date => date,
                      :severity => severity,
                      :action => action,
                      :outcome => outcome,
                      :fine => fine).first_or_create(version: @timestamp)

      nb = v.name.colorize(:blue)
      ib = i.iid.to_s.colorize(:blue)
      eb = v.eid.to_s.colorize(:blue)

      puts "#{n.to_s} ".colorize(:green) + "name:#{nb}, EID: #{eb}, IID: #{ib}" if n % 500 == 0

      n += 1
    end
    true
  end
end
