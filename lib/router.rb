require_relative 'client_parser'

# Defines routers
class Router
  def initialize
    @endpoints = {}
  end

  def get(endpoint, &handler)
    @endpoints['GET'] = {} if @endpoints['GET'].nil?
    @endpoints['GET'][endpoint] = handler
  end

  def post(endpoint, &handler)
    @endpoints['POST'] = {} if @endpoints['POST'].nil?
    @endpoints['POST'][endpoint] = handler
  end

  def get_set?(endpoint)
    return false if @endpoints['GET'].nil?
    return true if @endpoints['GET'][endpoint]
    false
  end

  def post_set?(endpoint)
    return false if @endpoints['POST'].nil?
    return true if @endpoints['POST'][endpoint]
    false
  end

  def set?(method, endpoint)
    if method == 'GET'
      return true if get_set?(endpoint)
    elsif method == 'POST'
      return true if post_set?(endpoint)
    end
    false
  end

  def execute(client)
    client_info = ClientParser.new(client).data
    method = client_info[:req].method
    path = client_info[:req].path
    endpoint = client_info[:req].endpoint

    is_set = set?(method.upcase, endpoint)
    color = is_set ? '32' : '31'

    puts "\e[#{color}m#{method}\e[0m #{path}"

    throw Exception.new unless is_set
    @endpoints[method]['*'].call unless @endpoints[method]['*'].nil?
    @endpoints[method][endpoint].call client_info[:req], client_info[:res]
  end
end
