require_relative 'http_server'

# Server runner
class Runner
  attr_reader :router

  def initialize(port = 9292)
    @server = HTTPServer.new port
    @router = @server.router
  end

  def start
    @server.start
  end

  def stop
    @server.close
  end
end