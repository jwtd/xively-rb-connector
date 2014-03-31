# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xively-rb-connector/version'

Gem::Specification.new do |spec|
  spec.name          = "xively-rb-connector"
  spec.version       = XivelyConnector::VERSION::STRING
  spec.authors       = ["Jordan Duggan"]
  spec.email         = ["Jordan.Duggan@gmail.com"]

  spec.summary       = %q{Ruby gem that provides a high level interface to Xively}
  spec.description   = %q{xively-rb-connector is a ruby gem that provides an interface to Xively (https://xively.com). It extends Sam Mulube's
excellent xively-rb (https://github.com/xively/xively-rb) gem. The xively-rb-connector gem adds convenience functions such as find_by_id
lookup functions, datastream compression (only saves datapoints when value changes), a datapoint recording buffer, etc.

Xively (https://xively.com/whats_xively) is a public cloud specifically built for the "Internet of Things". With their
platform, developers can connect physical devices, that produce one or more datastreams, to a managed data store. The
device's details and datastreams are accessible via key-based access to any service or application that has access to the
web. Xively provides a fantastic development portal and prototyping accounts are free.}

  spec.homepage      = "https://github.com/jwtd/xively-rb-connector"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.2"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"

  # Runtime dependencies
  spec.add_runtime_dependency "log4r", "~> 1.1"
  spec.add_runtime_dependency "xively-rb", "~> 0.2"
  spec.add_runtime_dependency "bigdecimal", "~> 1.2"

end
