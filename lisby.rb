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
        p(result)
      rescue SyntaxError, ArgumentError, NoMethodError => e
        e.backtrace
        retry
      end
    end
  end
end

Repl.new.execute
