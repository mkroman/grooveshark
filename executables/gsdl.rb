#!/usr/bin/env ruby
# encoding: utf-8

$:.unshift File.dirname(__FILE__) + '/../library'
require 'grooveshark'

client = Grooveshark::Client.new
client.search ARGV.join(' ') do |song|
  filename = "#{song.name} - #{song.artist}.mp3"

  puts "#{song.name} - #{song.artist} -> #{filename}"

  File.open filename, 'w+' do |file|
    song.stream.dump file
  end
end
