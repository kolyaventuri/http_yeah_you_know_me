class Router
  attr_reader :method
  
  def initialize(method)
    @method = method
    @endpoints = {}
  end
end