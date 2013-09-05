# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'formula_page/version'

Gem::Specification.new do |spec|
  spec.name          = "formula_page"
  spec.version       = FormulaPage::VERSION
  spec.authors       = ["Tommie Jones"]
  spec.email         = ["atlantageek@gmail.com"]
  spec.description   = %q{A tool that takes a excel document and generates a web page}
  spec.summary       = %q{A tool that takes an excel document and generates a web page}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
