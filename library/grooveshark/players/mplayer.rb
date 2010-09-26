# encoding: utf-8

module Grooveshark
  module Players
    class MPlayer
      attr_accessor :stream

      def initialize stream = nil
        @stream = stream
      end

      def play
        raise NoStreamAvailable unless @stream

        while @filename.nil? or File.exists? @filename
          @filename = random_name
          @path = Dir.tmpdir + "/#{@filename}"
        end

        %x{mkfifo #{@path}}
        Thread.new do
          %x{mplayer #{@path} -demuxer lavf -slave &> /dev/null}
        end
        stream!
      end

    private

      def stream!
        File.open @path, 'w' do |fifo|
          @stream.each_chunk do |chunk|
            fifo.write chunk
          end
        end
      end

      def random_name
        "grooveshark-#{rand(256 ** 3).to_s 16}"
      end
    end
  end
end
