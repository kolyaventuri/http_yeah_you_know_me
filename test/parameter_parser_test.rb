require_relative 'test_helper.rb'

require './lib/parameter_parser.rb'

class ParameterParserTest < Minitest::Test
  def test_does_create_parser
    parser = ParameterParser.new

    assert_instance_of ParameterParser, parser
  end

  def test_does_return_nil_parameters
    path = '/example'
    parser = ParameterParser.new

    parameters = parser.parse path

    assert_instance_of Hash, parameters
    assert_equal path, parameters[:path]
    assert_nil parameters[:parameters]
  end
end
