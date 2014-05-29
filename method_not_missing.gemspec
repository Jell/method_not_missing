# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'method_not_missing/version'

Gem::Specification.new do |spec|
  spec.name          = "method_not_missing"
  spec.version       = MethodNotMissing::VERSION
  spec.authors       = ["Jell"]
  spec.email         = ["jean-louis@jawaninja.com"]
  spec.summary       = %q{Implement missing methods by googling their implementation on the fly. Because Ruby.}
  spec.description   = %q{WARNING: CONTAINS TRACES OF SARCASM}
  spec.homepage      = "https://github.com/Jell/method_not_missing"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'poltergeist', '~> 1.5'
  spec.add_runtime_dependency 'capybara', '~> 2.2'
  spec.add_runtime_dependency 'launchy', '~> 2.4'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 10.3'
  spec.add_development_dependency "minitest", '~> 4.7'
end
