# encoding: utf-8

module GrooveShark
  class Connection
    GROOVE_PORT   = 443
    GROOVE_SERVER = "cowbell.grooveshark.com"

    UUID = "996A915E-4C56-6BE2-C59F-96865F748EAE"
    CLIENT = "gslite"
    CLIENT_REV = "20100412.09"

    def initialize session = nil
      @http = Net::HTTP.new GROOVE_SERVER, GROOVE_PORT
      @http.use_ssl = true
      @session = session
    end

    def transmit method, parameters = {}, more = false
      req = Net::HTTP::Post.new more ? '/more.php' : '/service.php'
      res = @http.request req, build(method, parameters)
      JSON.parse res.body
    end

  private
    def headers
      {
        "Content-Type" => "application/json",
        "Cookie" => "PHPSESSID=#{@session}"
      }
    end

    def build method, parameters
      {
        header: {
          session: @session,
           uuid: UUID,
           client: CLIENT,
           clientRevision: CLIENT_REV,
           country: {"CC1"=>"0","CC3"=>"0","ID"=>"223","CC2"=>"0","CC4"=>"1073741824"}
        },
        method: method,
        parameters: parameters
      }.to_json
    end
  end
end
