class Environment < Hash
  # @param [Environment] outer
  def initialize(params = [], args = [], outer = nil)
    h = Hash[params.zip(args)]
    merge!(h)
    merge!(yield) if block_given?
    @outer = outer
  end

  # @return [Environment] var
  def find(var)
    self.has_key?(var) ? self : @outer.find(var)
  end
end

# builtin functions
$global_env = Environment.new do
  {
    :+ => ->x,y{x+y},
    :- => ->x,y{x-y},
    :* => ->x,y{x*y},
    :/ => ->x,y{x/y},
    :not => ->x{!x},
    :> => -> x,y{x>y},
    :>= => -> x,y{x>=y},
    :< => -> x,y{x<y},
    :<= => -> x,y{x<=y},
    :'=' => -> x,y{x==y},
    :eq? => -> x,y {x.eql?(y)},
    :length => -> x {x.length},
    :cons => -> x,y {[x, y]},
    :car => -> x {x[0]},
    :list => -> *x {[*x]},
    :list? => -> x {x.instance_of?(Array)},
    :symbol? => -> x {x.instance_of?(Symbol)},
  }
end
