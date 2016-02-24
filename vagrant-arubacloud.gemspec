# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'vagrant-arubacloud/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-arubacloud'
  spec.version       = Vagrant::ArubaCloud::VERSION
  spec.authors       = ['Alessio Rocchi']
  spec.email         = ['alessio.rocchi@staff.aruba.it']
  spec.summary       = %q{Enables Vagrant to manage servers in ArubaCloud IaaS.}
  spec.description   = %q{Enables Vagrant to manage servers in ArubaCloud IaaS.}
  spec.homepage      = 'https://www.github.com/arubacloud/vagrant-arubacloud'
  spec.license       = 'MIT'

  spec.add_runtime_dependency 'fog', '~> 1.22'
  spec.add_runtime_dependency 'fog-arubacloud', '~> 0.0.2'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14.0'
  spec.add_development_dependency 'pry'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end
