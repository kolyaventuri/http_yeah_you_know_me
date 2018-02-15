require_relative 'client_parser'
require_relative 'routers/generic_router'

# Defines routers
class Router < GenericRouter
  def initialize
    @routers = {}
    @routers[:GET] = GenericRouter.new :GET
    @routers[:POST] = GenericRouter.new :POST
    @routers[:ERROR] = GenericRouter.new :ERROR

    define_default_error_handlers
  end

  def get(endpoint, &handler)
    router = @routers[:GET]
    router.set endpoint, &handler
  end

  def post(endpoint, &handler)
    router = @routers[:POST]
    router.set endpoint, &handler
  end

  def set?(method, endpoint)
    return false if @routers[method].nil?
    @routers[method].set? endpoint
  end

  def on(code, &handler)
    @routers[:ERROR].set code, &handler
  end

  def execute(client)
    client_info = client_info client
    router = @routers[client_info[:req].method]
    throw Exception.new if router.nil?
    router.execute client_info
  end

  def client_info(client)
    parser = ClientParser.new client
    parser.data
  end

  def define_default_error_handlers
    on 404 do |req, res|
      res.status 404
      res.send "Error 404: #{req.endpoint} Not Found"
    end
  end
end
