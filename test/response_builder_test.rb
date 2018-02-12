require_relative 'test_helper.rb'
require 'pry'

require './lib/response_builder.rb'

class ResponseBuilderTest < Minitest::Test
  def test_does_build_base_headers
    builder = ResponseBuilder.new
    output = [1, 2, 3, 4] # Dummy output, length 4
    headers = builder.headers output

    expected = ['http/1.1 200 OK',
                "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                'Server: ruby',
                'Content-Type: text/html; charset=iso-8859-1',
                "Content-Length: #{output.length}\r\n\r\n"].join('\r\n')

    assert_equal expected, headers
  end
end
