# encoding: utf-8

module Grooveshark
  class Queue < Array
    def add song; self << song end
    def fetch index, output; self[index].stream.dump output end
  end
end
