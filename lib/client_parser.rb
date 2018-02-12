require_relative 'client/request'
require_relative 'client/response'

# Parses client data into req and res parameters
class ClientParser
  def initialize(client)
    @request = Request.new client
    @response = Response.new client, @request.raw_headers
  end

  def data
    { req: @request, res: @response }
  end
end