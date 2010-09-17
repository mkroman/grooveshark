# encoding: utf-8

require 'json'
require 'net/http'
require 'digest/sha1'

module GrooveShark
  class Connection
    attr_accessor :session

    GROOVE_PORT   = 443
    GROOVE_SERVER = "cowbell.grooveshark.com"

    UUID = "996A915E-4C56-6BE2-C59F-96865F748EAE"
    CLIENT = "gslite"
    CLIENT_REV = "20100412.09"

    def initialize session = nil
      @http = Net::HTTP.new GROOVE_SERVER, GROOVE_PORT
      @http.use_ssl = true
      @session = session || new_session
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


    def token method
      token = rand(256 ** 3).to_s(16).rjust 6, '0'
      plain = [method, @token, 'quitStealinMahShit', token].join ?:
      "#{token}#{Digest::SHA1.hexdigest plain}"
    end

    def new_session
      response = Net::HTTP.get URI.parse("http://listen.grooveshark.com/")
      response =~ /sessionID: '([0-9a-f]+)'/ ? $1 : nil
    end
  end
end
