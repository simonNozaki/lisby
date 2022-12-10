require(File.join(File.dirname(__FILE__ ), 'lib/lisby/version'))

Gem::Specification.new do |spec|
  spec.name    = 'lisby'
  spec.version = Lisby::VERSION

  spec.authors = ['simonnozaki']

  spec.summary     = 'Tiny lisp interpreter'
  spec.license     = 'Unlicense'
  spec.homepage    = 'https://github.com/simonNozaki/lisby'

  spec.bindir      = 'exe'
  spec.executables = ['lumise']
  spec.files       = Dir['lib/**/*']

  spec.required_ruby_version = '~> 2.7.6'
end
