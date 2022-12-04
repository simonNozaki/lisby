class Environment < Hash
  # @param [Environment] outer
  def initialize(params = [], args = [], outer = nil)
    h = Hash[params.zip(args)]
    merge!(h)
    @outer = outer
  end

  def find_variable(var)
    has_key?(var) ? self : @outer.find_variable(var)
  end
end
