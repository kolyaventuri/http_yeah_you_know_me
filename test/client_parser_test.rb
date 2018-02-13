require_relative 'test_helper.rb'

require './lib/client_parser'
require './lib/client/request'
require './lib/client/response'
require_relative 'fixtures/mock_client'

class ClientParserTest < Minitest::Test
  def test_can_parse_client
    client = MockClient.new
    parser = ClientParser.new client

    expected_response = Response.new client, client.headers
    expected_request = Request.new client

    expected = { req: expected_request, res: expected_response }

    assert_equal expected, parser.data
  end
end