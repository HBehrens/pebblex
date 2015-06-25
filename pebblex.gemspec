# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pebble_x/version'

Gem::Specification.new do |spec|
  spec.name          = "pebblex"
  spec.version       = PebbleX::VERSION
  spec.authors       = ["Heiko Behrens"]
  spec.email         = ["HeikoBehrens@gmx.de"]
  spec.summary       = %q{Enables Pebble development with Xcode and AppCode.}
  spec.description   = %q{Creates an Xcode project from a pebble project that contains the needed search paths, resources and .c files to start right away. Each time you build your watch app from the IDE, all warnings and errors of the underlying ´pebble build` command will be presented right in the editor. With AppCode you can even build, install the .pbw to your watch, and look at the live logs as a one-step action directly from your IDE!}
  spec.homepage      = "https://github.com/hbehrens/pebblex"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency(%q<thor>, ["~> 0.18.1"])
  spec.add_runtime_dependency(%q<xcodeproj>, ["~> 0.24.2"])

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "rspec-mocks", "~> 2.14"
  spec.add_development_dependency "rake"
end
