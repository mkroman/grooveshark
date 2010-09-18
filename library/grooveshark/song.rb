# encoding: utf-8

module GrooveShark
  class Song
    def self.attr_data name, field
      define_method name do; @data[field] end
    end

    attr_data :id,     'SongID'
    attr_data :name,   'Name'
    attr_data :album,  'AlbumName'
    attr_data :artist, 'ArtistName'

    def initialize data = {}, delegate = nil
      @delegate = delegate
      @data = data
    end

    def token
      unless @token
        stream = @delegate.transmit :getTokenForSong, {
          songID: id,
          country: {"CC1"=>"0","CC3"=>"0","ID"=>"223","CC2"=>"0","CC4"=>"1073741824"}
        }, true

        @token = stream['Token']
      end

      @token
    end

    def url
      name = self.name.gsub(/[^\s\w]/, '').gsub ' ', '+'
      %{http://listen.grooveshark.com/#/s/#{name}/#{token}}
    end

    alias_method :link, :url

  end
end
