require('./environment')

class Interpreter
  def interpret(x, env = $global_env)
    case x
    when Symbol
      env.find(x)[x]
    when Array
      case x.first
      when :quote
        _, exp = x
        exp
      when :if
        _, test, conseq, alt = x
        result = interpret(test, env) ? conseq : alt
        interpret(result, env)
      when :set!
        _, var, exp = x
        env.find(var)[var] = interpret(exp, var)
      when :define
        _, var, exp = x
        env[var] = interpret(exp, env)
        nil
      when :lambda
        _, vars, exp = x
        lambda { |*args| interpret(exp, Environment.new(vars, args, env)) }
      when :begin
        x[1..-1].inject(nil) { |val, exp| val = interpret(exp, env) }
      else
        proc, *exps = x.inject([]) { |mem, exp| mem << interpret(exp, env) }
        proc[*exps]
      end
    else
      x
    end
  end
end
