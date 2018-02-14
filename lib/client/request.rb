require_relative '../parameter_parser'
require_relative '../body_parser'

# Defines incoming client request data
class Request
  attr_reader :headers,
              :method,
              :path,
              :endpoint,
              :params,
              :raw_headers

  def initialize(client)
    @client = client
    @headers = {}
    @params = {}

    request_content = get_request_content

    @raw_headers = request_content[:headers]
    request_content[:headers].each do |header|
      split_header = header.split(':')
      name = split_header.shift
      @headers[name] = split_header.join(':').strip
    end
    endpoint_data = determine_endpoint @raw_headers[0]
    @method = endpoint_data[:method]
    @path = endpoint_data[:endpoint]

    @raw_headers[0] = "#{@method} #{@path} HTTP/1.1"

    parameters = parse_parameters @path
    @endpoint = parameters[:path]

    @params = parameters[:parameters] unless parameters[:parameters].nil?
  end

  def get_request_content
    lines = request_lines
    headers = read_headers lines
    body = read_body lines
    { body: body, headers: headers }
  end

  def read_headers(lines)
    headers = []
    while (line = lines.shift) && !line.chomp.empty?
      headers.push line
    end
    lines.shift
    headers
  end

  def read_body(lines)
    body = []
    while (line = lines.shift) && !line.nil?
      body.push line unless line.chomp.empty?
    end
    body
  end

  def parse_parameters(path)
    parser = ParameterParser.new
    parser.parse path
  end

  def parse_body(body)
    parser = BodyParser.new
    parser.parse body
  end

  def request_lines
    request_lines = []
    while (line = @client.gets) && !line.nil?
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
    { method: :GET, endpoint: endpoint }
  end

  def post_endpoint_info(endpoint)
    endpoint.slice!(0, 5)
    endpoint.slice!(endpoint.length - 9, endpoint.length - 1)
    { method: :POST, endpoint: endpoint }
  end
end