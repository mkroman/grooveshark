# encoding: utf-8

require 'json'
require 'net/http'
require 'net/https'
require 'digest/md5'
require 'digest/sha1'

module Grooveshark
  class Connection
    attr_accessor :token, :session

    DefaultPort = 443
    DefaultHost = "cowbell.grooveshark.com"

    UUID = '996A915E-4C56-6BE2-C59F-96865F748EAE'
    ClientName = 'gslite'
    ClientRevision = '20100831.17'

    def initialize
      @http = Net::HTTP.new DefaultHost, DefaultPort
      @http.use_ssl = true

      # Session data
      @session = new_session
      @token   = new_token
    end

    def transmit method, parameters = {}, more = false
      req = Net::HTTP::Post.new more ? '/more.php' : '/service.php', headers
      res = @http.request req, build(method, parameters)
      result = JSON.parse res.body

      if result['fault'] and result['fault']['code'] == 256
        @token = new_token
        return transmit method, parameters, more
      end

      result['result'] or result['fault']
    end

  private
    def headers
      {
        "Content-Type" => "application/json",
        "Cookie" => "PHPSESSID=#{@session}"
      }
    end

    def build method, parameters
      buffer = {
        header: {
           session: @session,
           uuid: UUID,
           client: ClientName,
           clientRevision: ClientRevision,
           country: Grooveshark::Country
        },
        method: "#{method}",
        parameters: parameters
      }

      buffer[:header][:token] = generate_token(method) if @token
      buffer.to_json
    end


    def generate_token method
      token = rand(256 ** 3).to_s(16).rjust 6, '0'
      plain = [method, @token, 'quitStealinMahShit', token].join ?:
      "#{token}#{Digest::SHA1.hexdigest plain}"
    end

    def new_session
      response = Net::HTTP.get URI.parse("http://listen.grooveshark.com/")
      response =~ /sessionID: '([0-9a-f]+)'/ ? $1 : nil
    end

    def new_token
      transmit :getCommunicationToken, secretKey: Digest::MD5.hexdigest(@session)
    end
  end
end
