require_relative 'test_helper.rb'

require './lib/body_builder.rb'

class BodyBuilderTest < Minitest::Test
  def test_does_build_body_correctly
    builder = BodyBuilder.new
    request_headers = [
      'GET / HTTP/1.1',
      'Host: localhost:9292',
      'Connection: keep-alive',
      'Cache-Control: no-cache'
    ]
    expected = [
      '1234',
      '<pre>',
      'GET / HTTP/1.1',
      'Host: localhost:9292',
      'Connection: keep-alive',
      'Cache-Control: no-cache',
      '</pre>'
    ].join("\n")

    body = builder.body('1234', request_headers)
    assert_equal expected, body
  end
end