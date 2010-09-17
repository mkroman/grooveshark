# encoding: utf-8

module GrooveShark
  class Connection
    GROOVE_PORT   = 443
    GROOVE_SERVER = "cowbell.grooveshark.com"

    def initialize server, session = nil
      @http = Net::HTTP.new GROOVE_SERVER, GROOVE_PORT
      @http.use_ssl = true
    end

  private
    def headers
      {
        "Content-Type" => "application/json",
        "Cookie" => "PHPSESSID=#{@session}"
      }
    end
  end
end
