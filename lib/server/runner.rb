require './lib/runner'
require './lib/dictionary/complete_me'
require 'pry'

dictionary = CompleteMe.new
words = File.read('/usr/share/dict/words')
dictionary.populate(words)

runner = Runner.new
router = runner.router
hello_times = 0
request_count = 0

game_running = false
right_guess = 0
guesses = []

router.get '*' do
  request_count += 1
end

router.post '*' do
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

router.post '/start_game' do |_req, res|
  game_running = true
  right_guess = (0..100).to_a.sample
  res.send 'Good luck!'
end

router.get '/game' do |_req, res|
  out = "#{guesses.length} guesses have been taken."
  unless guesses.last.nil?
    out += "\n\n"
    out += "Your most recent guess, #{guesses.last}, was #{check_guess(guesses.last)}"
  end
  res.send out
end

router.post '/game' do |req, res|
  guess = req.body['guess'].to_i
  guesses.push guess
  res.set_header 'Location', '/game'
  res.status 302
  res.send ''
end

def check_guess(guess)
  return 'too low.' if guess < right_guess
  return 'too high.' if guess > right_guess
  'correct!'
end

runner.start
