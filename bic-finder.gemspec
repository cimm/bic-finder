require_relative 'lib/version'

Gem::Specification.new do |gem|
  gem.name          = 'bic-finder'
  gem.version       = BicFinder::VERSION
  gem.authors       = ['Simon Schoeters']
  gem.email         = 'cimm@github'
  gem.summary       = 'Finds the BIC for a European IBAN.'
  gem.description   = 'Can calculate the Business Identifier Code (BIC) for the bank and branch of a limited set of International Bank Account Numbers (IBAN). Only banks active in Belgium are supported at the moment but other countries can easily be added.'
  gem.homepage      = 'https://github.com/cimm/bic-finder'
  gem.license       = 'MIT'
  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ['lib']
  gem.test_files    = gem.files.grep(%r{^(test)/})

  gem.add_development_dependency 'minitest', '~> 5.11', '>= 5.11.0'
  gem.add_development_dependency 'rake',     '~> 10.0', '>= 10.0.0'
  gem.add_development_dependency 'vcr',      '~> 4.0', '>= 4.0.0'
  gem.add_development_dependency 'webmock',  '~> 3.4',  '>= 3.4.0'

  gem.add_runtime_dependency     'iso-iban',    '~> 0.1', '>= 0.1.0'
  gem.add_runtime_dependency     'roo',         '~> 2.7', '>= 2.7.0'
  gem.add_runtime_dependency     'rubyzip',     '~> 1.0', '>= 1.0.0'
  gem.add_runtime_dependency     'smarter_csv', '~> 1.2', '>= 1.2.5'
end
