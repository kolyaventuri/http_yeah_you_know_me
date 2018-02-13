require_relative 'test_helper.rb'

require './lib/parameter_parser.rb'

class ParameterParserTest < Minitest::Test
  def test_does_create_parser
    parser = ParameterParser.new

    assert_instance_of ParameterParser, parser
  end
end
