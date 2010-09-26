#!/usr/bin/env ruby
# encoding: utf-8

$:.unshift File.dirname(__FILE__) + '/../library'
require 'grooveshark'

@player = Grooveshark::Players::MPlayer.new

results = Grooveshark.search "ohoi"
results.first.tap do |song|
  @player.stream = song.stream
  @player.play
end
