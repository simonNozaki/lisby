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
        # Multiple substitution from array to variables
        # `x` is array and should have condition, consequence and alt
        _, condition, conseq, alt = x
        result = interpret(condition, env) ? conseq : alt
        interpret(result, env)
      when :set!
        _, var, exp = x
        env.find(var)[var] = interpret(exp, var)
      when :def
        _, var, exp = x
        env[var] = interpret(exp, env)
        var
      when :lambda
        _, vars, exp = x
        lambda { |*args| interpret(exp, Environment.new(vars, args, env)) }
      when :begin
        x[1..-1].inject(nil) { |val, exp| val = interpret(exp, env) }
      else
        p x
        proc, *exps = x.inject([]) { |mem, exp| mem << interpret(exp, env) }
        p proc
        p *exps.to_a
        proc[*exps]
      end
    else
      x
    end
  end
end
