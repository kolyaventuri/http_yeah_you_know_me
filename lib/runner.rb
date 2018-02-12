require_relative 'http_server'

# Server runner
class Runner
  attr_reader :router

  def initialize
    @server = HTTPServer.new
    @router = @server.router
  end

  def start
    @server.start
    #server.close
  end
end