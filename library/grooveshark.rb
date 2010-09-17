# encoding: utf-8

require 'grooveshark/song'
require 'grooveshark/queue'
require 'grooveshark/client'
require 'grooveshark/connection'

module GrooveShark
  VERSION = [0, 0, 1]

  class << self
    def search query, &proc
      client.search query, &proc
    end

    def client
      @client ||= GrooveShark::Client.new
    end
  end
end
