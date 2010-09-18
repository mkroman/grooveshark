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

      songs.map do |song|
        yield Song.new song, @connection
      end
    end
  end
end
