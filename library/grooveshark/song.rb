# encoding: utf-8

module GrooveShark
  class Song
    def self.attr_data name, field
      define_method name do; @data[field] end
    end

    attr_data :name,   'Name'
    attr_data :album,  'AlbumName'
    attr_data :artist, 'ArtistName'

    def initialize data = {}
      @data = data
    end

  end
end
