class Question
  attr_reader :text, :answers, :right_answers

  def initialize(text, answers, right_answers)
    @text = text
    @answers = answers
    @right_answers = right_answers
  end
end
