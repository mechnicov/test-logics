require 'timeout'
require 'csv'
require_relative 'lib/test'
require_relative 'lib/question'
require_relative 'lib/result'

current_path = __dir__
questions_path = current_path + '/data/questions.csv'
results_path = current_path + '/data/results.csv'

test = Test.new(questions_path, results_path)

STDOUT.puts "Сейчас будет проведён #{test.name}, у Вас будет #{test.test_time_in_min}"
STDOUT.puts "Количество вопросов: #{test.questions_quantity}."
STDOUT.puts test.description

start = nil
until start == 'старт'
  STDOUT.puts 'Наберите СТАРТ, если готовы'
  start = STDIN.gets.chomp.downcase
end

timeout = false

begin
  Timeout::timeout(test.test_time) do
    until test.finished?
      STDOUT.puts test.ask_current_question
      user_answer = STDIN.gets.chomp.downcase
      test.check_current_answer(user_answer)
    end
  end
rescue Timeout::Error
  timeout = true
end

STDOUT.puts "\nВы не уложились в #{test.test_time_in_min}" if timeout
STDOUT.puts test.result
