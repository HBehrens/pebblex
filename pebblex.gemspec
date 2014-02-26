# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pebble_x/version'

Gem::Specification.new do |spec|
  spec.name          = "pebblex"
  spec.version       = PebbleX::VERSION
  spec.authors       = ["Heiko Behrens"]
  spec.email         = ["HeikoBehrens@gmx.de"]
  spec.summary       = %q{Some additions to the pebble CLI.}
  spec.description   = %q{For now, it can create and Xcode project from a pebble dir. In future, some other convenience commands will be added.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency(%q<thor>, ["~> 0.18.1"])
  spec.add_runtime_dependency(%q<xcodeproj>, ["~> 0.14.1"])

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "rspec-mocks", "~> 2.14"
  spec.add_development_dependency "rake"
end
