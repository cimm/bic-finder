# BICFinder

A Ruby gem to find the BIC (Bank Identification Code) for a given IBAN (International Bank Account Number). Useful when your application asks people's bank accounts but they don't always know the matching BIC (or worse, they enter the wrong one).

Currently, the following countries are supported, other countries can be added if we find an official source:

- Austria ([Oesterreichische Nationalbank](https://www.oenb.at/idakilz/kiverzeichnis?lang=en))
- Belgium ([National Bank of Belgium](https://www.nbb.be/en/payments-and-securities/payment-standards/bank-identification-codes))
- Germany ([Deutche Bundesbank](https://www.bundesbank.de/en/tasks/payment-systems/services/bank-sort-codes/))

## Installing

```bash
gem install bic-finder
```

or add it to your Gemfile

```ruby
gem 'bic-finder', '~> 0.0.0'
```

## Usage

```ruby
require 'bic-finder'
BicFinder::Bank.update_all
bank = BicFinder::Bank.find_by_iban('BE68 5390 0754 7034')
bank.bic
#=> "NAP"
bank.names
#=> {:nl=>"Onbeschikbaar", :fr=>"Indisponible"}
bank.name(locale: :nl)
#=> "Onbeschikbaar"
```

Don't forget to run `update_all` at least once, it will download the data files to your temp folder. You can re-run this command periodically to update the data files.

## Configuration

The cache directory defaults to the system cache dir but can be configured if you don't like this:

```ruby
BicFinder.configure do |config|
  config.check_dir = 'your-prefered-directory'
end
```

## Contributing

Contributions welcome! Adding an unsupported country would be a great help! Official sources are prefered, the National Bank of the country is probably the best place to start.
