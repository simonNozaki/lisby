module Lisby
  module Kernel
    def Symbol(obj)
      # internで文字列・数値リテラルをシンボルにできる
      obj.intern
    end
  end
end
