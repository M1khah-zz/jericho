# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jericho/version'

Gem::Specification.new do |spec|
  spec.name          = "jericho"
  spec.version       = Jericho::VERSION
  spec.authors       = ["Kirill"]
  spec.email         = ["alexeyenko92@gmail.com"]

  spec.summary       = %q{"Additional gem for cucumber tests"}
  spec.description   = %q{"Tiny simple gem which cleans your cucumber JSON reports from redundant info and compares report from your last test run and report from previous test run. After it you'll receive a test run summary to desired slack channel. Please note that in order to use slack integration - you'll need to configure dotenv gem with your Slack credentials"}
  spec.homepage      = "https://github.com/M1khah/jericho"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency 'dotenv', "~> 2.7"
  spec.add_runtime_dependency 'slack-ruby-client', "~> 0.14.1"
end
