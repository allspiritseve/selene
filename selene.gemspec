# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'selene/version'

Gem::Specification.new do |gem|
  gem.name          = "selene"
  gem.version       = Selene::VERSION
  gem.authors       = ["Cory Kaufman-Schofield"]
  gem.email         = ["cory@corykaufman.com"]
  gem.description   = %q{Selene is an iCalendar parser for Ruby}
  gem.summary       = %q{Selene is an iCalendar parser for Ruby}
  gem.homepage      = "https://github.com/allspiritseve/selene"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'ice_cube'

  gem.add_development_dependency 'byebug'
  gem.add_development_dependency 'minitest-reporters'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-minitest'
end
