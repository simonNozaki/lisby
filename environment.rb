require('set')

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
    :and => -> x,y { x and y },
    :or => -> x,y { x or y },
    :eq? => -> x,y {x.eql?(y)},
    :length => -> x {x.length},
    :display => -> *x { p(*x) },
    :odd? => -> x { x % 2 != 0 },
    :even? => -> x { x % 2 == 0 },
    :negative? => -> x { x < 0 },
    :'nat-int?' => -> x { x.instance_of?(Integer) and x > 0 },
    :abs => -> x { x.abs },
    :float => -> x { x.to_f }, # coerce to float
    :int => -> x { x.to_i }, # coerce to integer
    :rand => -> x do
      return rand if x.nil?
      rand(x)
    end,
    :cons => -> x,y {[x, y]},
    :first => -> x {x[0]},
    :last => -> x { x[x.length - 1] },
    :conj => -> x,y do
      # 一度シリアライズして別のオブジェクトにすることで全く別のオブジェクトにできる
      a = Marshal.load(Marshal.dump(x))
      a.push(y)
      a
    end,
    :conj! => -> x, y { x.push(y) },
    :disj => -> x, y do
      a = Marshal.load(Marshal.dump(x))
      a.delete(y)
      a
    end,
    :disj! => -> x, y { x.delete(y) },
    :get => -> x, y { x[y] },
    :repeat => -> x, y do
      a = []
      x.times do
        a.push(y)
      end
      a
    end,
    # x: lambda, y: a list lambda applied
    :some => -> x, y { !y.filter(&x).empty? },
    :filter => -> x, y { y.filter(&x) },
    :map => -> x, y { y.map(&x) },
    :every? => -> x, y { y.all?(&x) },
    :empty? => -> x { x.empty? },
    :inc => -> x { x + 1 },
    :list => -> *x { [*x] },
    :max => -> *x { [*x].max },
    :min => -> *x { [*x].min },
    :range => -> x, y do
      a = y.nil? ? 1..x : x..y
      a.to_a
    end,
    :list? => -> x {x.instance_of?(Array)},
    :set => -> *x { Set[*x] },
    :set? => -> x { x.instance_of?(Set) },
    :symbol? => -> x {x.instance_of?(Symbol)},
    :integer? => -> x { x.instance_of?(Integer) },
  }
end
