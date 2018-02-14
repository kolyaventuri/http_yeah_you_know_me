require './lib/runner'
require './lib/dictionary/complete_me'
require 'pry'

runner = Runner.new
router = runner.router

router.get '/' do |req, res|
  res.send 'Hi'
end

router.post '/' do |req, res|
  print req.body
  puts ''
  res.send 'Success'
end

runner.start
