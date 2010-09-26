# encoding: utf-8

module Grooveshark
  class Song
    class InvalidStream < StandardError; end

    def self.attr_data name, field
      define_method name do; @data[field] end
    end

    attr_data :id,     'SongID'
    attr_data :name,   'Name'
    attr_data :album,  'AlbumName'
    attr_data :artist, 'ArtistName'

    def initialize data = {}, connection = nil
      @connection = connection
      @data = data
    end

    def token; @token ||= get_token end
    def stream; @stream ||= Stream.new get_stream, self end

    def url
      name = self.name.gsub(/[^\s\w]/, '').gsub ' ', '+'
      %{http://listen.grooveshark.com/#/s/#{name}/#{token}}
    end

  private

    def get_token
      result = @connection.transmit :getTokenForSong, {
        songID: id,
        country: Grooveshark::Country
      }, true

      result['Token']
    end

    def get_stream
      result = @connection.transmit :getStreamKeyFromSongIDEx, {
        prefetch: false,
        country: Grooveshark::Country,
        mobile: false,
        songID: id,
      }, true

      raise InvalidStream if result.empty?

      { key: result['streamKey'], ip: result['ip'] }
    end
  end
end
