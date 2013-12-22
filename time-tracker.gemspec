# -*- encoding: utf-8 -*-
require File.expand_path('../lib/time_tracker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "time-tracker"
  gem.version       = TimeTracker::VERSION
  gem.authors       = ["Alec Tower"]
  gem.email         = ["alectower@gmail.com"]
  gem.description   = %q{}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/uniosx/time_tracker"
  gem.platform      = Gem::Platform::RUBY
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency 'rspec'
end
