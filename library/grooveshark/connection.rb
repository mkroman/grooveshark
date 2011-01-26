# encoding: utf-8

module Grooveshark
  class Connection
    attr_accessor :token, :session

    DefaultPort = 443
    DefaultHost = "cowbell.grooveshark.com"

    def initialize
      @http = Net::HTTP.new DefaultHost, DefaultPort
      @http.use_ssl = true

      @session = get_session
      @token = get_token
    end

    def transmit method, parameters = {}, more = false
       request = Net::HTTP::Post.new '/more.php', headers
      response = @http.request request, build(method, parameters)
        result = JSON.parse response.body

      if result['fault'] and result['fault']['code'] == 256
        @token = get_token

        return transmit method, parameters, more
      end

      result['result'] or result['fault']
    end

  private

    def headers
      {
        "Cookie" => "PHPSESSID=#{@session}",
        "Content-Type" => "application/json"
      }
    end

    def build method, parameters
      buffer = {
        header: {
           uuid: Grooveshark::UUID,
           session: @session,
           client: Grooveshark::ClientName,
           clientRevision: Grooveshark::ClientRevision,
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

    def get_session
      request  = Net::HTTP::Get.new '/'
      response = Net::HTTP.start 'listen.grooveshark.com', 80 do |http|
        http.request request
      end

      response['Set-Cookie'] =~ /PHPSESSID=(.*?);/ ? $1 : nil
    end

    def get_token
      transmit :getCommunicationToken, secretKey: Digest::MD5.hexdigest(@session)
    end
  end
end
