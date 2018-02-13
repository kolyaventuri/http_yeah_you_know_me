require_relative 'test_helper'
require './lib/dictionary/complete_me.rb'
require './lib/dictionary/node.rb'

class CompleteMeTest < Minitest::Test

  def test_head_node_starts_empty
    completion = CompleteMe.new
    assert_instance_of Node, completion.head
    assert_nil completion.head.character
  end

  def test_count_starts_empty
    completion = CompleteMe.new
    assert_equal 0, completion.count
  end

  def test_insert_accepts_strings
    completion = CompleteMe.new
    completion.insert('word')
    assert_equal ['word'], completion.suggest('word')
  end

  def test_populate_populates
    completion = CompleteMe.new
    dictionary = File.read('./data/words.sample.txt')
    completion.populate(dictionary)

    assert_equal ['a', 'aardvark'], completion.suggest('a')
    assert_equal ['pizza'], completion.suggest('p')
    assert_equal [], completion.suggest('c')
  end

  def test_insert_increases_count
    completion = CompleteMe.new
    assert_equal 0, completion.count
    completion.insert('word')
    assert_equal 1, completion.count
  end

  def test_suggest_works_properly
    completion = CompleteMe.new
    dictionary = File.read('./data/words.sample.txt')

    completion.populate(dictionary)
    assert_equal ['a', 'aardvark'], completion.suggest('a')
  end
end
