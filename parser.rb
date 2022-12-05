class Parser
  include(Kernel)

  # Parse and return symbols
  # @return [Array] tokens
  def parse(str)
    tokens = tokenize(str)
    read_from(tokens)
  end

  # @param [String] str
  # @return [Array] tokens
  def tokenize(str)
    str.gsub(/[()]/, ' \0 ').split
  end

  # @param [Array] tokens
  def read_from(tokens)
    raise(SyntaxError, 'unexpected EOF while reading') if tokens.empty?
    case token = tokens.shift
    when '('
      l = []
      until tokens[0] == ')'
        symbol = read_from(tokens)
        l.push(symbol)
      end
      tokens.shift
      l
    when ')'
      raise(SyntaxError, 'unexpected ")"')
    else
      atom(token)
    end
  end

  def atom(token)
    type = [:Integer, :Float, :Symbol]
    begin
      send(type.shift, token)
    rescue ArgumentError
      retry 
    end
  end
end
