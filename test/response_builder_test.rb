require_relative 'test_helper.rb'

require './lib/response_builder.rb'

class ResponseBuilderTest < Minitest::Test

  def test_does_build_base_headers
    builder = ResponseBuilder.new
    output = [1, 2, 3, 4] # Dummy output, length 4
    headers = builder.header_string output

    expected = ['HTTP/1.1 200 OK',
                "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                'Server: ruby',
                'Content-Type: text/html; charset=iso-8859-1',
                "Content-Length: #{output.length}\r\n\r\n"].join("\r\n")

    assert_equal expected, headers
  end

  def test_has_headers_array
    builder = ResponseBuilder.new

    expected = ['HTTP/1.1 200 OK',
                'Date: ',
                'Server: ruby',
                'Content-Type: text/html; charset=iso-8859-1',
                "Content-Length: \r\n\r\n"]
    assert_equal expected, builder.headers_array
  end

  def test_builds_header
    builder = ResponseBuilder.new
    output = 'a'
    expected = ['HTTP/1.1 200 OK',
                "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                'Server: ruby',
                'Content-Type: text/html; charset=iso-8859-1',
                "Content-Length: #{output.length}\r\n\r\n"].join("\r\n")
    assert_equal expected, builder.header_string(output)
  end

  def test_can_change_status
    builder = ResponseBuilder.new
    output = [1, 2, 3, 4] # Dummy output, length 4
    builder.status 404
    headers = builder.header_string output

    expected = ['HTTP/1.1 404 Not Found',
                "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                'Server: ruby',
                'Content-Type: text/html; charset=iso-8859-1',
                "Content-Length: #{output.length}\r\n\r\n"].join("\r\n")

    assert_equal expected, headers
  end

  def test_can_set_arbitrary_header
    builder = ResponseBuilder.new
    output = [1, 2, 3, 4] # Dummy output, length 4
    builder.set_header "X-Foo", "Bar"
    headers = builder.header_string output

    expected = ['HTTP/1.1 200 OK',
                "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                'Server: ruby',
                'Content-Type: text/html; charset=iso-8859-1',
                "Content-Length: #{output.length}",
                "X-Foo: Bar\r\n\r\n"].join("\r\n")

    assert_equal expected, headers
  end

  def test_does_expose_headers
    builder = ResponseBuilder.new
    expected = {
      status: 'HTTP/1.1 200 OK',
      'Date' => nil,
      'Server' => 'ruby',
      'Content-Type' => 'text/html; charset=iso-8859-1',
      'Content-Length' => nil
    }

    assert_equal expected, builder.headers
  end
end
