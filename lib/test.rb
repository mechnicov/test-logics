class Test
  TEST_TIME = 480

  def initialize(questions_path, results_path)
    read_questions_from(questions_path)
    read_results_from(results_path)
    @current_id = -1
    @score = 0
  end

  def ask_current_question
    @current_id += 1
    "#{@questions[@current_id]} \n #{@answers[@current_id]}"
  end

  def check_current_answer(user_answer)
    @score += 1 if user_answer == @right_answers[@current_id]
  end

  def finished?
    @current_id >= @questions.size - 1
  end

  def name
    'Тест на логическое мышление'
  end

  def description
    'Необходимо определить формальную правильность того или ' \
      'иного логического умозаключения на основе определенного утверждения ' \
      '(или ряда утверждений). В случае, если ответов несколько, их  ' \
      'необходимо вводить без пробела'
  end

  def questions_quantity
    @questions.size
  end

  def test_time
    TEST_TIME
  end

  def test_time_in_min
    hours = TEST_TIME / 3600
    hours == 0 ? hours = '' : hours = "#{hours} ч "

    minutes = TEST_TIME / 60 % 60
    minutes == 0 ? minutes = '' : minutes = "#{minutes} мин. "

    seconds = TEST_TIME % 60
    seconds == 0 ? seconds = '' : seconds = "#{seconds} сек. "

    "#{hours}#{minutes}#{seconds}"
  end

  def result
    user_result = nil
    @results_ranges.each_with_index do |range, index|
      user_result = index if range.include?(@score)
    end

    "\nРезультат теста:\nКоличество верных ответов: #{@score}\n#{@results[user_result]}"
  end

  private

  def read_questions_from(questions_path)
    questions      =
                     CSV.
                       read(questions_path, headers: true).
                       map { |line| Question.new(line['Вопрос'], line['Варианты ответов'], line['Правильный ответ']) }
    @questions     = questions.map(&:text)
    @answers       = questions.map(&:answers)
    @right_answers = questions.map(&:right_answers)
  end

  def read_results_from(results_path)
    results         =
                      CSV.
                        read(results_path, headers: true).
                        map { |line| Result.new(line['Результат'], (line['от'].to_i..line['до'].to_i)) }
    @results        = results.map(&:text)
    @results_ranges = results.map(&:range)
  end
end
