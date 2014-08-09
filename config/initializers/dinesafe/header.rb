class Header
  attr_reader :url

  def initialize(u)
    @url = u
  end

  def header
    connection = Faraday.new(:url => url) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end

    connection.get.headers
  end

  def last_modified
    self.header['last-modified'].to_time.to_i
  end
end