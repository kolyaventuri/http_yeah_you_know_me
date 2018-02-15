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

  def execute(client_info, code = nil)
    method = client_info[:req].method
    path = client_info[:req].path
    endpoint = client_info[:req].endpoint unless code
    endpoint = code if code
    is_set = set?(endpoint)
    color = is_set ? '32' : '31'

    puts "\e[#{color}m#{method}\e[0m #{path}"

    call_catch_all
    return 404 unless is_set
    call_path endpoint, client_info
  end
end
