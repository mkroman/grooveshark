# encoding: utf-8

require 'json'
require 'tmpdir'
require 'net/http'
require 'net/https'
require 'singleton'
require 'digest/md5'
require 'digest/sha1'

require 'grooveshark/song'
require 'grooveshark/stream'
require 'grooveshark/client'
require 'grooveshark/connection'

module Grooveshark
  class << Version = [0,2]
    def to_s; join '.' end
  end

  UUID = 'E2AB1A59-C6B7-480E-992A-55DE1699D7F8'
  ClientName = 'htmlshark'
  ClientRevision = '20101012.37'

  Country = { CC1: 0, CC3: 0, ID: 223, CC2: 0, CC4: 1073741824 }

  class << self
    def search query, &block
      Client.instance.search query, &block
    end
  end
end
