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

class DinesafeScraper
  attr_accessor :xml_file_path

  def initialize(archive)
    @xml_file_path = archive.fullpath
  end

  def parse
    # set up Nokogiri
    xml_parser = Nokogiri::XML(File.open(@xml_file_path))

    # splits the xml file into single inspection chunks (see top of file)
    i = xml_parser.css('ROWDATA ROW')

    # counter for output
    n = 0

    i.each_with_index do |row|
      x = Inspection.create(rid:      row.xpath('ROW_ID').text.to_i,
                            eid:      row.xpath('ESTABLISHMENT_ID').text.to_i,
                            iid:      row.xpath('INSPECTION_ID').text.to_i,
                            name:     row.xpath('ESTABLISHMENT_NAME').text,
                            etype:    row.xpath('ESTABLISHMENTTYPE').text,
                            status:   row.xpath('ESTABLISHMENT_STATUS').text,
                            details:  row.xpath('INFRACTION_DETAILS').text,
                            date:     row.xpath('INSPECTION_DATE').text,
                            severity: row.xpath('SEVERITY').text,
                            action:   row.xpath('ACTION').text,
                            outcome:  row.xpath('COURT_OUTCOME').text,
                            fine:     row.xpath('AMOUNT_FINED').text,
                            address:  row.xpath('ESTABLISHMENT_ADDRESS').text,
                            mipy:     row.xpath('MINIMUM_INSPECTIONS_PERYEAR').text.to_i
      )
      # only print out every 500th venue
      puts "name: #{x.name}, RID: #{x.rid}, IID: #{x.iid}" if n % 500 == 0

      n += 1
    end
  end
end
