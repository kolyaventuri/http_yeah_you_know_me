require 'socket'
require_relative 'response_builder'
require_relative 'body_builder'
require_relative 'router'

# HTTPServer provider
class HTTPServer
  attr_reader :server, :router

  def initialize(port = 9292)
    puts "Staring server on port #{port}"
    @server = TCPServer.new port
    @router = Router.new
    @threads = []
  end

  def start
    loop do
      t = Thread.new(@server.accept) do |client|
        # TODO: Something in here is causing an EBADF error on @server.close
        # Need to look into it
        @router.execute(client)
      end
      @threads.push t
    end
  end

  def close
    puts 'Server is closing'
    @server.close
    @threads.each(&:kill)
  end

  def open?
    !@server.closed?
  end
end