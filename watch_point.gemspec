# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'watch_point/version'

Gem::Specification.new do |spec|
  spec.name          = "watch_point"
  spec.version       = WatchPoint::VERSION
  spec.authors       = ["Chris Yuen"]
  spec.email         = ["chris@kizzx2.com"]
  spec.description   = %q{Lightweight watchpoint implementation}
  spec.summary       = %q{Lightweight watchpoint implementation}
  spec.homepage      = "https://github.com/kizzx2/watch_point"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'pry', '>= 0.9.0'
end
