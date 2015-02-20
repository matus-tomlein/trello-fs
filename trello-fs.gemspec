# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trello-fs/version'

Gem::Specification.new do |spec|
  spec.name          = "trello-fs"
  spec.version       = Goulash::VERSION
  spec.authors       = ["Matúš Tomlein"]
  spec.email         = ["matus@tomlein.org"]
  spec.summary       = %q{A utility for archiving Trello boards into Git repositories.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/matus_tomlein/trello-fs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "ruby-trello", "~> 1.1"
end
