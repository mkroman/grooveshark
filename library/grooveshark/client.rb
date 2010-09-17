# encoding: utf-8

module GrooveShark
  class Client
    COWBELL = 'cowbell.grooveshark.com'

    def initialize
      # …
    end

    def search query
      yield Song.new({
        'Name' => 'Den lukrative rendesten',
        'ArtistName' => 'L.O.C.'
      })if block_given?
    end
  end
end
