# encoding: utf-8

module GrooveShark
  class Client

    def initialize
      @connection = Connection.new
    end

    def search query
      songs = @connection.transmit :getSearchResults, {
        type: :Songs,
        query: query
      }, true

      songs.map! &Song.method(:new)
      songs.each{|s| yield s} if block_given?
    end
  end
end
