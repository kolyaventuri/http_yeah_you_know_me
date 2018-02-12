# Defines incoming client request data
class Request
  attr_reader :headers, :method, :path, :raw_headers

  def initialize(client)
    @client = client
    @headers = {}

    request_headers = request_lines
    @raw_headers = request_headers
    request_headers.each do |header|
      split_header = header.split(':')
      name = split_header.shift
      @headers[name] = split_header.join(':').strip
    end

    endpoint_data = determine_endpoint @raw_headers[0]
    @method = endpoint_data[:method]
    @path = endpoint_data[:endpoint]
    @raw_headers[0] = "#{@method} #{@path} HTTP/1.1"
  end

  def request_lines
    request_lines = []
    while (line = @client.gets) && !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def determine_endpoint(endpoint)
    if endpoint.slice(0, 3) == 'GET'
      return get_endpoint_info endpoint
    elsif endpoint.slice(0, 4) == 'POST'
      return post_endpoint_info endpoint
    end
    { method: nil, endpoint: nil }
  end

  def get_endpoint_info(endpoint)
    endpoint.slice!(0, 4)
    endpoint.slice!(endpoint.length - 9, endpoint.length - 1)
    { method: 'GET', endpoint: endpoint }
  end

  def post_endpoint_info(endpoint)
    endpoint.slice!(0, 5)
    endpoint.slice!(endpoint.length - 9, endpoint.length - 1)
    { method: 'POST', endpoint: endpoint }
  end
end