require('./kernel')
require('./environment')
require('./interpreter')
require('./parser')
require('readline')

class Repl
  def initialize
    @parser = Parser.new
    @interpreter = Interpreter.new
  end

  # Print a result of REPL process
  def print(expression)
    p expression.instance_of?(Array) ? "[#{expression.map(&:to_s).join(' ')}]" : expression
  end

  # Start REPL process
  def execute
    loop do
      begin
        line = Readline.readline("lisby> ", true)
        next if line.nil? || line.empty?
        if line == "quit"
          p "Bye!"
          break
        end
        symbols = @parser.parse(line)
        result = @interpreter.interpret(symbols, $global_env)
        print(result) unless result.nil?
      rescue SyntaxError, ArgumentError, NoMethodError => e
        e.backtrace
        retry
      end
    end
  end
end

Repl.new.execute
