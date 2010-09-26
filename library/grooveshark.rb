# encoding: utf-8

require 'tmpdir'
require 'grooveshark/song'
require 'grooveshark/queue'
require 'grooveshark/stream'
require 'grooveshark/client'
require 'grooveshark/connection'
require 'grooveshark/players/mplayer'

module Grooveshark
  Version = [0, 0, 1]
  Country = {"CC1"=>"0","CC3"=>"0","ID"=>"223","CC2"=>"0","CC4"=>"1073741824"}

  class << self
    def search query, &block
      client.search query, &block
    end

    def client
      @client ||= Client.new
    end
  end
end
