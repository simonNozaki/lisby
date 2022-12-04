class Interpreter
  def interpret(x, env = $global_env)
    case x
    when Symbol
      env.find_variable(x)[x]
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
        env.find_variable(var)[var] = interpret(exp, var)
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
        proc, *exps = x.inject([]) { |mem, exp| mem << evaluate(exp, env) }
        proc.call(*exps)
      end
    end
  end
end
