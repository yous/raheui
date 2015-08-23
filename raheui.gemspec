# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'raheui/version'

Gem::Specification.new do |spec|
  spec.name          = 'raheui'
  spec.version       = Raheui::Version::STRING
  spec.authors       = ['Chayoung You']
  spec.email         = ['yousbe@gmail.com']
  spec.summary       = 'Aheui interpreter in Ruby.'
  spec.description   = 'Aheui interpreter in Ruby.'
  spec.homepage      = 'https://github.com/yous/raheui'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.33.0'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'fasterer', '~> 0.1.0'
end
