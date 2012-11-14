# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chinchilla/version'

Gem::Specification.new do |gem|
  gem.name          = "chinchilla"
  gem.version       = Chinchilla::VERSION
  gem.authors       = ["tchak"]
  gem.email         = ["paul@chavard.net"]
  gem.description   = %q{mocha test runner}
  gem.summary       = %q{Run mocha test on Capybara}
  gem.homepage      = ""

  gem.add_dependency 'capybara'
  gem.add_dependency 'poltergeist'
  gem.add_dependency 'rocha'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
