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

    # endpoint_data = determine_endpoint @raw_headers[0]
    # @method = endpoint_data[:method]
    # @path = endpoint_data[:endpoint]
    #
    # @raw_headers[0] = "#{@method} #{@path} HTTP/1.1"
    #
    # parameters = parse_parameters @path
    # @endpoint = parameters[:path]
    #
    # @params = parameters[:parameters] unless parameters[:parameters].nil?
    #
    # @body = {}
    # if @method == :POST
    #   @body = request_body
    # end
  end

  def parse_client
    parse_headers

    endpoint_data = determine_endpoint @raw_headers[0].clone
    @method = endpoint_data[:method]
    @path = endpoint_data[:path]

    parameters = parse_parameters @path
    @endpoint = parameters[:endpoint]
    @params = parameters[:parameters]
  end

  def parse_headers
    @raw_headers = read_request_headers @client
    @headers = request_headers raw_headers
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

  def request_body
    length = @headers['Content-Length'].to_i
    body = @client.readpartial length
    parse_body body
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

  def parse_body(body)
    parser = BodyParser.new
    parser.parse body
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