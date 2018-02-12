require 'socket'
require_relative 'response_builder'
require_relative 'body_builder'
require_relative 'router'

# HTTPServer provider
class HTTPServer
  attr_reader :server, :router

  def initialize(port = 9292)
    @server = TCPServer.new port
    @router = Router.new
  end

  def start
    loop do
      break if @server.closed?
      Thread.new(@server.accept) do |client|
        # endpoint = determine_endpoint client
        @router.execute(client)
      end
    end
  end

  def close
    @server.close
  end

  def open?
    !@server.closed?
  end
end