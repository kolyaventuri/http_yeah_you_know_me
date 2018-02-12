require_relative 'test_helper.rb'

require './lib/response_builder.rb'

class ResponseBuilderTest < Minitest::Test
  def test_does_build_base_headers
    builder = ResponseBuilder.new
    output = [1, 2, 3, 4] # Dummy output, length 4
    headers = builder.headers output

    expected = ['http/1.1 200 ok',
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                'server: ruby',
                'content-type: text/html; charset=iso-8859-1',
                "content-length: #{output.length}\r\n\r\n"].join('\r\n')
    assert_equal expected, headers
  end
end
