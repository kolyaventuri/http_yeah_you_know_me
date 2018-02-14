require_relative 'test_helper.rb'

require './lib/body_parser.rb'

class BodyParserTest < Minitest::Test
  def setup
    @parser = BodyParser.new
  end

  def test_does_create_parser
    assert_instance_of BodyParser, @parser
  end

  def test_does_parse_request_body
    body = 'foo=bar&bar=foo'
    expected = { foo: 'bar', bar: 'foo' }

    assert_equal expected, @parser.parse(body)
  end
end