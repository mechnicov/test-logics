class Test
  attr_reader :right_answers

  def initialize(voprosnik, rezultaty)
    @questions = voprosnik.map { |value| { text:         value[0],
                                           answers:      value[1],
                                           right_answer: value[2] } }

    @results = rezultaty.map { |value| { text: value[0],
                                         from: value[1].to_i,
                                         to:   value[2].to_i } }

    @current_id = -1
    @right_answers = 0
  end

  def ask_current_question
    @current_id += 1
    "#{@questions[@current_id][:text]} \n #{@questions[@current_id][:answers]}"
  end

  def check_current_answer(user_answer)
    @right_answers +=1 if user_answer == @questions[@current_id][:right_answer]
  end

  def is_finished?
    @current_id >= @questions.length - 1
  end

  def name
    'Тест на логическое мышление'
  end

  def intro
    'Необходимо определить формальную правильность того или ' \
      'иного логического умозаключения на основе определенного утверждения ' \
      '(или ряда утверждений). В случае, если ответов несколько, их  ' \
      'необходимо вводить без пробела'
  end

  def test_time
    480
  end

  def test_time_in_min
    hours = test_time / 3600
    hours == 0 ? hours = '' : hours = "#{ hours } ч"

    minutes = test_time / 60
    minutes == 0 ? minutes = '' : minutes = "#{ minutes } мин."

    seconds = test_time % 60
    seconds == 0 ? seconds = '' : seconds = " #{ seconds } сек."

    "#{ hours } #{ minutes } #{ seconds }"
  end

  def result
    user_result = nil
    @results.each_with_index do |value, index|
      user_result = index if @right_answers.between?(value[:from], value[:to])
    end

    @results[user_result][:text]
  end
end
