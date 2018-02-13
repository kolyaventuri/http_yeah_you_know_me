class Node
  attr_reader :character
  attr_accessor :weights, :child_nodes, :word

  def initialize(character, word = nil)
    @character = character
    @word = word
    @child_nodes = {}
    @weights = []
  end
end
