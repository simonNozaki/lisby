require('./environment')

class Interpreter
  def interpret(x, env = $global_env)
    case x
    when Symbol
      if x == :true or x == :false
        return get_bool(x)
      end

      env.find(x)[x]
    when Array
      case x.first
      when :quote
        _, exp = x
        exp
      when :if
        # Multiple substitution from array to variables
        # `x` is array and should have condition, consequence and alt
        _, condition, conseq, alt = x
        result = interpret(condition, env) ? conseq : alt
        interpret(result, env)
      when :set!
        _, var, exp = x
        env.find(var)[var] = interpret(exp, var)
      when :define
        _, var, exp = x
        env[var] = interpret(exp, env)
        var
      when :lambda
        _, vars, exp = x
        lambda { |*args| interpret(exp, Environment.new(vars, args, env)) }
      when :begin
        x[1..-1].inject(nil) { |val, exp| val = interpret(exp, env) }
      when :true || :false
        get_bool(x.first)
      when :let
        _, var_pairs, expression = x
        if var_pairs.first.instance_of?(Symbol)
          env[var_pairs.first] = interpret(var_pairs[1], env)
        else
          var_pairs.each do |pair|
            env[pair.first] = interpret(var_pairs[1], env)
          end
        end
        interpret(expression, env)
      else
        proc, *exps = x.inject([]) { |mem, exp| mem << interpret(exp, env) }
        proc[*exps]
      end
    else
      x
    end
  end

  private
    # @param [Symbol] symbol
    def get_bool(symbol)
      bool = {
        true: true,
        false: false
      }
      bool[symbol]
    end
end
