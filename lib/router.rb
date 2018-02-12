# Defines routers
class Router
  def initialize
    @endpoints = {}
  end

  def get(endpoint, handler)
    @endpoints['GET'] = {} if @endpoints['GET'].nil?
    @endpoints['GET'][endpoint] = handler
  end

  def post(endpoint, handler)
    @endpoints['POST'] = {} if @endpoints['POST'].nil?
    @endpoints['POST'][endpoint] = handler
  end

  def get_set?(endpoint)
    return true if @endpoints['GET'][endpoint]
    false
  end

  def post_set?(endpoint)
    return true if @endpoints['POST'][endpoint]
    false
  end

  def set?(method, endpoint)
    if method == 'GET'
      return true if get_set?(endpoint)
    elsif method == 'POST'
      return true if post_set?(endpoint)
    else
      false
    end
  end

  def execute(method, endpoint, args)
    throw Exception.new unless set?(method.upcase, endpoint)
    @endpoints[method][endpoint].call args
  end
end
