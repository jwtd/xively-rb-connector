# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xively-rb-connector/version'

Gem::Specification.new do |spec|
  spec.name          = "xively-rb-connector"
  spec.version       = XivelyConnector::VERSION::STRING
  spec.authors       = ["Jordan Duggan"]
  spec.email         = ["Jordan.Duggan@gmail.com"]
  spec.description   = %q{Ruby gem that provides an interface to Xively by extending xively-rb with convenience functions such Device.find_by_id, a datastream compression (only saves datapoints when value changes), a datapoint recording buffer, etc.}
  spec.summary       = %q{Ruby gem that provides an interface to Xively by extending xively-rb with convenience functions such Device.find_by_id, a datastream compression (only saves datapoints when value changes), a datapoint recording buffer, etc.}
  spec.homepage      = "https://github.com/jwtd/xively-rb-connector"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  # Runtime dependencies
  spec.add_runtime_dependency "log4r"
  spec.add_runtime_dependency "xively-rb"
  spec.add_runtime_dependency "bigdecimal"

end
