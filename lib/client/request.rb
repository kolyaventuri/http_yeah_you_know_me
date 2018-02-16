require_relative '../parameter_parser'
require_relative '../body_parser'

# Defines incoming client request data
class Request
  attr_reader :headers,
              :method,
              :path,
              :endpoint,
              :params,
              :body,
              :raw_headers

  def initialize(client)
    @client = client

    @raw_headers = []
    @headers = {}

    @method = nil
    @path = ''
    @endpoint = ''

    @params = {}
    @body = {}

    parse_client

  end

  def parse_client
    parse_headers

    endpoint_data = determine_endpoint @raw_headers[0].clone
    @method = endpoint_data[:method]
    @path = endpoint_data[:path]

    extract_parameters @path

    @body = request_body if @method == :POST
  end

  def parse_headers
    @raw_headers = read_request_headers @client
    @headers = request_headers raw_headers
  end

  def extract_parameters(path)
    if path
      parameters = parse_parameters path
      @endpoint = parameters[:endpoint]
      @params = parameters[:parameters] unless parameters[:parameters].nil?
    else
      @endpoint = nil
      @params = {}
    end
  end

  def request_headers(raw_headers)
    headers = {}
    raw_headers.each do |header|
      split_header = header.split(':')
      name = split_header.shift
      headers[name] = split_header.join(':').strip
    end

    headers
  end

  def read_body
    length = @headers['Content-Length'].to_i
    @client.readpartial length
  end

  def request_body
    parse_body read_body, @headers['Content-Type']
  end

  def read_request_headers(client)
    request_lines = []
    while (line = client.gets) && !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def parse_parameters(path)
    parser = ParameterParser.new
    parser.parse path
  end

  def parse_body(body, content_type = 'application/x-www-form-urlencoded')
    parser = BodyParser.new
    parser.parse body, content_type
  end

  def determine_endpoint(endpoint)
    if endpoint.slice(0, 3) == 'GET'
      return get_endpoint_info endpoint
    elsif endpoint.slice(0, 4) == 'POST'
      return post_endpoint_info endpoint
    end
    { method: nil, path: nil }
  end

  def get_endpoint_info(endpoint)
    endpoint.slice!(0, 4)
    endpoint.slice!(endpoint.length - 9, endpoint.length - 1)
    { method: :GET, path: endpoint }
  end

  def post_endpoint_info(endpoint)
    endpoint.slice!(0, 5)
    endpoint.slice!(endpoint.length - 9, endpoint.length - 1)
    { method: :POST, path: endpoint }
  end
end