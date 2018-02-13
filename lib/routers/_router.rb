class Router
  attr_reader :method

  def initialize(method)
    @method = method
    @endpoints = {}
  end

  def set(endpoint, handler)
    @endpoints[endpoint] = handler
  end

  def set?(endpoint)
    return true if @endpoints[endpoint]
    false
  end
end