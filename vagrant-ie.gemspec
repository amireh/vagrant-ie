# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "vagrant-ie"
  spec.version       = "1.0.0"
  spec.authors       = ["Ahmad Amireh"]
  spec.email         = ["ahmad@amireh.net"]
  spec.summary       = "Vagrant plugin for IE automation."
  spec.homepage      = "https://github.com/amireh/vagrant-ie"
  spec.license       = "BSD-3"
  spec.description   = <<-EOF
vagrant-ie is a plugin for vagrant that automates provisioning a Windows 7
box for IE testing. The plugin works in both headless and GUI provider modes.
EOF

  spec.files         = Dir.glob("{lib,spec}/**/*")
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rails', [ '>= 5', '< 6' ]
  spec.add_development_dependency 'rspec', '~> 3.5'
end