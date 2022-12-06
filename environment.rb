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
    :% => -> x,y { x % y },
    :not => ->x{!x},
    :> => -> x,y{x>y},
    :>= => -> x,y{x>=y},
    :< => -> x,y{x<y},
    :<= => -> x,y{x<=y},
    :'=' => -> x,y{x==y},
    :eq? => -> x,y {x.eql?(y)},
    :length => -> x {x.length},
    :display => -> *x { p(*x) },
    :odd? => -> x { x % 2 != 0 },
    :even? => -> x { x % 2 == 0 },
    :rand => -> x do
      return rand if x.nil?
      rand(x)
    end,
    :cons => -> x,y {[x, y]},
    :first => -> x {x[0]},
    :last => -> x { x[x.length - 1] },
    :list => -> *x {[*x]},
    :list? => -> x {x.instance_of?(Array)},
    :symbol? => -> x {x.instance_of?(Symbol)},
    :integer? => -> x { x.instance_of?(Integer) },
    :conj => -> x,y do
      # 一度シリアライズして別のオブジェクトにすることで全く別のオブジェクトにできる
      a = Marshal.load(Marshal.dump(x))
      a.push(y)
      a
    end,
  }
end
