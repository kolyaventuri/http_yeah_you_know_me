require_relative '../client_parser'

# Defines generic router
class GenericRouter
  attr_reader :method

  def initialize(method)
    @method = method
    @endpoints = {}
  end

  def set(endpoint, &handler)
    @endpoints[endpoint] = handler
  end

  def set?(endpoint)
    return true if @endpoints[endpoint]
    false
  end

  def call_catch_all
    @endpoints['*'].call unless @endpoints['*'].nil?
  end

  def call_path(path, client_info)
    @endpoints[path].call client_info[:req], client_info[:res]
  end

  def execute(client_info)
    method = client_info[:req].method
    path = client_info[:req].path
    endpoint = client_info[:req].endpoint
    is_set = set?(endpoint)
    color = is_set ? '32' : '31'

    puts "\e[#{color}m#{method}\e[0m #{path}"

    return 404 unless is_set
    call_catch_all
    call_path endpoint, client_info
    200
  end
end
