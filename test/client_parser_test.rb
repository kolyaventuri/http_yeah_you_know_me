require_relative 'test_helper.rb'

require './lib/client_parser'
require './lib/client/request'
require './lib/client/response'
require_relative 'fixtures/mock_client'

class ClientParserTest < Minitest::Test
  def test_can_parse_client
    client = MockClient.new
    parser = ClientParser.new client

    client = MockClient.new
    expected_response = Response.new client, client.headers
    expected_request = Request.new client

    expected = { req: expected_request, res: expected_response }

    assert_instance_of Request, parser.data[:req]
    assert_instance_of Response, parser.data[:res]
    assert_equal expected[:req].raw_headers, parser.data[:req].raw_headers
  end
end