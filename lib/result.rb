class Result
  attr_reader :text, :range

  def initialize(text, range)
    @text = text
    @range = range
  end
end
