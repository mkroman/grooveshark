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

      songs.map! { |song| Song.new song, @connection }
      songs.each { |song| yield song } if block_given?

      songs
    end
  end
end
