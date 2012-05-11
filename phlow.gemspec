# -*- encoding: utf-8 -*-
require File.expand_path('../lib/phlow/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Isa Goksu"]
  gem.email         = ["isa.goksu@gmail.com"]
  gem.description   = %q{A custom git workflow that actually works with CI environment}
  gem.summary       = %q{Git-flow is awesome, this gem is just enhancing the workflow to make it work with CI tools like Teamcity, Jenkins, etc. Gem includes bunch of command line wrapper utilities around Git.}
  gem.homepage      = "https://github.com/isa/phlow"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "phlow"
  gem.require_paths = ["lib"]
  gem.version       = Phlow::VERSION

  gem.add_development_dependency('rspec')
end
