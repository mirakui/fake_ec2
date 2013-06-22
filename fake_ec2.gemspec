# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fake_ec2/version'

Gem::Specification.new do |spec|
  spec.name          = "fake_ec2"
  spec.version       = FakeEc2::VERSION
  spec.authors       = ["Issei Naruta"]
  spec.email         = ["naruta@cookpad.com"]
  spec.description   = %q{fake_ec2: Amazon EC2 mock for testing}
  spec.summary       = %q{Amazon EC2 mock for testing}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ["server"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sinatra', '~> 1.4'
end
