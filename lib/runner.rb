require_relative 'http_server'

# Server runner
class Runner
  attr_reader :router, :server

  def initialize
    @server = HTTPServer.new
    @router = @server.router
  end

  def start
    @server.start
  end

  def stop
    @server.close
  end
end