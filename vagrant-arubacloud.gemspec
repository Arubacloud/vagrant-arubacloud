# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'vagrant-arubacloud/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-arubacloud'
  spec.version       = Vagrant::ArubaCloud::VERSION
  spec.authors       = ['Aruba S.p.A.']
  spec.email         = ['cloudsdk@staff.aruba.it']
  spec.summary       = %q{Enables Vagrant to manage servers in ArubaCloud IaaS.}
  spec.description   = %q{Enables Vagrant to manage servers in ArubaCloud IaaS; this version support 'reload' and 'snapshot' option}
  spec.homepage      = 'https://www.github.com/arubacloud/vagrant-arubacloud'
  spec.license       = 'MIT'

  spec.add_runtime_dependency 'fog', '~> 1.22'
  spec.add_runtime_dependency 'fog-arubacloud', '~> 0.0', '>= 0.0.6'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake' , '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.7'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end
