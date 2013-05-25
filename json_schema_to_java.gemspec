# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "json_schema_to_java"
  gem.version       = '1.0'
  gem.authors       = ["Glenn Nagel"]
  gem.email         = ["glenn@mercury-wireless.com"]
  gem.homepage      = "https://github.com/gnagel/json_schema_to_java"
  gem.summary       = %q{Convert a JSON Schema to a basic Java + ORMLite class for Android}
  gem.description   = %q{}
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib", "tasks"]

  # System
  gem.add_dependency('require_all')
  gem.add_dependency('hash_plus', '>= 1.3')

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('rspec-expectations')
end
