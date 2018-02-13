require './lib/runner'
require './lib/dictionary/complete_me'

dictionary = CompleteMe.new
words = File.read('/usr/share/dict/words')
dictionary.populate(words)

runner = Runner.new
router = runner.router
hello_times = 0
request_count = 0

router.get '*', (proc do
  request_count += 1
end)

router.get '/', (proc do |_req, res|
  res.send ''
end)

router.get '/hello', (proc do |_req, res|
  res.send "Hello, world! (#{hello_times += 1})"
end)

router.get '/datetime', (proc do |_req, res|
  res.send Time.now.strftime('%l:%M%p on %A, %B %e, %Y')
end)

router.get '/shutdown', (proc do |_req, res|
  res.send "Total Requests: #{request_count}"
  runner.server.close
end)

router.get '/word_search', (proc do |req, res|
  word = req.params['word']
  return res.send 'No word supplied' if word.nil?
  res.send word
end)

runner.start
