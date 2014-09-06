# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape/resources/version'

Gem::Specification.new do |spec|
  spec.name          = "grape-resources"
  spec.version       = Grape::Resources::VERSION
  spec.authors       = ["Antonio Pagano, Israel De La Hoz"]
  spec.email         = ["israeldelahoz@gmail.com", "ap@wawand.co"]
  spec.summary       = %q{ Grape resources provides the initial scaffolding for a model in a Grape api object }
  spec.description   = %q{ Grape resources provides the initial scaffolding for a model in a Grape api object, this gem in inspired by inherited-resources gem, and aims to solve this need inside a grape API.}
  spec.homepage      = "https://github.com/wawandco/grape-resources"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 10'
  spec.add_development_dependency "rspec", '~> 3'
  spec.add_development_dependency "sqlite3", '~> 1.3'
  spec.add_development_dependency "factory_girl", '~> 3'
  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'database_cleaner', '~> 1.3'
  spec.add_development_dependency "rack-test", '~> 0'
  spec.add_development_dependency "codeclimate-test-reporter", '~> 0'
  
  
  spec.add_runtime_dependency "grape", '~> 0.9'
  spec.add_runtime_dependency "activerecord", '~> 4'
  spec.add_runtime_dependency "activesupport", '~> 4'
  spec.add_runtime_dependency 'active_model_serializers', '~> 0.9'
end
