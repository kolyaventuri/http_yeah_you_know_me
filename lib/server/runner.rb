require './lib/runner'
require './lib/DICTIONARY/complete_me'

require 'json'
require 'pry'

DICTIONARY = CompleteMe.new
words = File.read('/usr/share/dict/words')
DICTIONARY.populate(words)

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
  if req.headers['HTTP-Accept'] == 'application/json'
    suggest_json word, res
  else
    suggest_plain_text word, res
  end
end

def suggest_plain_text(word, res)
  return res.send 'No word supplied' if word.nil?
  options = DICTIONARY.suggest word
  if options.include? word
    res.send "#{word} is a known word"
  else
    res.send "#{word} is not a known word"
  end
end

def suggest_json(word, res)
  res.set_header 'Content-Type', 'application/json'
  result = { word: word, is_word: true }
  if word.nil?
    result[:is_word] = false
    return res.send result.to_json
  end

  options = DICTIONARY.suggest word
  check_options word, options, res
end

def check_options(word, options, res)
  result = { word: word, is_word: true }

  if options.empty?
    result[:is_word] = false
  elsif options.length > 1 && !options.include?(word)
    result[:word] = options.first
    result[:possible_matches] = options
    res.send result.to_json
  end

  res.send result.to_json
end

router.post '/start_game' do |_req, res|
  if game_running
    res.status 403
    res.send 'Game is already running'
  else
    game_running = true
    guesses = []
    right_guess = (0..100).to_a.sample
    res.send 'Good luck!'
  end
end

router.get '/game' do |_req, res|
  out = "#{guesses.length} guesses have been taken."
  unless guesses.last.nil?
    out += "\n\n"
    out += "Your most recent guess, #{guesses.last}, was #{check_guess(guesses.last, right_guess)}"
  end
  res.send out
end

router.post '/game' do |req, res|
  guess = req.body['guess'].to_i
  game_running = false if guess == right_guess
  guesses.push guess
  res.redirect '/game'
end

router.get '/force_error' do |_req, res|
  res.status 500
  begin
    Math.sqrt(-1)
  rescue => e
    out = 'An error was encountered. Stack trace below<br /><br />'
    out += e.backtrace.join("\n")
    res.send out
  end
end

def check_guess(guess, right_guess)
  return 'too low.' if guess < right_guess
  return 'too high.' if guess > right_guess
  'correct!'
end

runner.start
