require 'timeout'
require 'csv'
require_relative 'test'

questions = CSV.read('questions.csv')
results = CSV.read('results.csv')
test = Test.new(questions, results)

STDOUT.puts "Сейчас будет #{test.name}, у Вас#{test.test_time_in_min}"
STDOUT.puts "Количество вопросов: #{questions.length}."
STDOUT.puts test.intro

poehali = nil
until poehali == 'тест'
  STDOUT.puts 'Наберите ТЕСТ, если готовы'
  poehali = STDIN.gets.chomp.downcase
end

timeout = false

begin
  status = Timeout::timeout(test.test_time) do
    until test.is_finished?
      STDOUT.puts test.ask_current_question
      user_answer = STDIN.gets.chomp.downcase
      test.check_current_answer(user_answer)
    end
  end
rescue Timeout::Error
  timeout = true
end

STDOUT.puts "\nРезультат теста:"
STDOUT.puts "\nВы не уложились в #{test.test_time_in_min}" if timeout
STDOUT.puts "\nКоличество верных ответов: #{test.right_answers}"
STDOUT.puts test.result
