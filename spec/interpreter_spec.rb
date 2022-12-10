require 'rspec'
require 'lisby/interpreter'
require 'lisby/environment'

module Lisby
  describe('InterpreterSpec') do
    Environment = Lisby::Environment
    interpreter = Lisby::Interpreter.new
    empty_env = Environment.new

    context('when defining') do

      it('should be integer literal') do
        symbols = 1
        result = interpreter.interpret(symbols, empty_env)
        expect(result).to(eq(1))
      end

      it('should define a simple variable') do
        symbols = [:define, :n, 1]
        e = Environment.new
        result = interpreter.interpret(symbols, e)
        expect(result).to(eq(:n))
        expect(e[:n]).to(eq(1))
      end

      it('should define function with a variavle') do
        # (define plus1 (lambda (n) (+ n 1)))
        symbols = [:define, :plus1, [:lambda, [:n], [:+, :n, 1]]]
        e = Environment.new
        result = interpreter.interpret(symbols, e)
        expect(result).to(eq(:plus1))
        expect(e[:plus1]).to(be_instance_of(Proc))
      end
    end

    context('when calling builtin functions') do
      it('should be a list') do
        symbols = [:list, 1, 3, 5]
        result = interpreter.interpret(symbols, $global_env)
        expect(result).to(be_instance_of(Array))
        expect(result.length).to(eq(3))
      end
    end
  end
end