require './lib/runner'
require './lib/dictionary/complete_me'

dictionary = CompleteMe.new
words = File.read('/usr/share/dict/words')
dictionary.populate(words)

runner = Runner.new
router = runner.router
hello_times = 0
request_count = 0

router.get '*' do |req, res|
  request_count += 1
end

router.post '*' do |req, res|
  request_count += 1
end

router.get '/' do |_req, res|
  res.send ''
end

router.get '/hello' do |_req, res|
  res.send "Hello, world! (#{hello_times += 1})"
end

router.get '/datetime' do |_req, res|
  res.send Time.now.strftime('%l:%M%p on %A, %B %e, %Y')
end

router.get '/shutdown' do |_req, res|
  res.send "Total Requests: #{request_count}"
  runner.server.close
end

router.get '/word_search' do |req, res|
  word = req.params['word']
  return res.send 'No word supplied' if word.nil?
  options = dictionary.suggest word
  if options.include? word
    res.send "#{word} is a known word"
  else
    res.send "#{word} is not a known word"
  end
end

router.post '/test' do |req, res|
  print req.body
  puts ''
  res.send 'hi'
end

runner.start
