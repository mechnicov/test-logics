require 'timeout'
require 'csv'

begin
  require_relative 'lib/test'
rescue LoadError
  abort 'Файлы программы повреждены'
end

begin
  questions = CSV.read('data/questions.csv')
  results = CSV.read('data/results.csv')
rescue SystemCallError
  abort 'Отсутствуют файлы для проведения теста'
end

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

STDOUT.puts "\nРезультат теста:"
STDOUT.puts "\nВы не уложились в: #{test.test_time_in_min}" if timeout
STDOUT.puts "\nКоличество верных ответов: #{test.right_answers}"
STDOUT.puts test.result
