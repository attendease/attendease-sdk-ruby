# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attendease_sdk/version'

Gem::Specification.new do |spec|
  spec.name          = "attendease_sdk"
  spec.version       = AttendeaseSDK::VERSION
  spec.authors       = ["Jamie Lubiner"]
  spec.email         = ["jamie@attendease.com"]

  spec.summary       = "AttendeaseSDK for Ruby"
  spec.description   = "A Ruby wrapper for the Attendease API"
  spec.homepage      = "https://github.com/attendease/attendease-sdk-ruby"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 13.0", ">= 13.0.6"
  spec.add_development_dependency "rspec", "~> 2.12"
  spec.add_development_dependency "pry", "~> 0"

  spec.add_dependency "httparty", "~> 0.13", ">= 0.13.7"
  spec.add_dependency "activesupport", "~> 3.2.22", ">= 3.2.22.2"
end
