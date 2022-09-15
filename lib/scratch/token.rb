class Scratch::Token
  attr_reader :type, :lexeme

  def initialize(type, lexeme = nil)
    @type = type.to_sym
    @lexeme = lexeme || type
  end
end
