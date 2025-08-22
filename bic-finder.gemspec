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

  gem.add_development_dependency 'minitest', '~> 5.25', '>= 5.11.0'
  gem.add_development_dependency 'rake',     '~> 13.3', '>= 10.0.0'
  gem.add_development_dependency 'vcr',      '~> 6.0', '>= 4.0.0'
  gem.add_development_dependency 'webmock',  '~> 3.6',  '>= 3.4.0'

  gem.add_runtime_dependency     'iso-iban',    '~> 0.1', '>= 0.1.0'
  gem.add_runtime_dependency     'roo',         '~> 2.10', '>= 2.8.2'
  gem.add_runtime_dependency     'rubyzip',     '~> 2.0', '>= 1.0.0'
  gem.add_runtime_dependency     'smarter_csv', '~> 1.14', '>= 1.2.5'
end
