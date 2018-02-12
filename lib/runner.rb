require_relative 'http_server'

class Runner
  def start
    server = HTTPServer.new
    server.start
    #server.close
  end
end