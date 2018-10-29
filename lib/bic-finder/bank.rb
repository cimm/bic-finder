require 'iso/iban'

module BicFinder
  class Bank
    include ISO

    attr_reader :bic, :names

    def self.update_all
      AustrianBank.update
      BelgianBank.update
      GermanBank.update
    end

    def self.valid_update?
      Digest::MD5.file(data_file).hexdigest == self::SOURCE_CHECKSUM
    end

    def self.find_by_iban(iban)
      iban = IBAN.parse(iban)
      find(iban.bank_code, iban.country)
    end

    def self.find(bank_code, country_code)
      case country_code
      when 'AT' then AustrianBank.find_in_country(bank_code)
      when 'BE' then BelgianBank.find_in_country(bank_code)
      when 'DE' then GermanBank.find_in_country(bank_code)
      end
    end

    def initialize(bic, names)
      @bic   = bic
      @names = names
    end

    def name(locale: nil)
      locale ? @names[locale] : @names.values.compact.first
    end
  end
end
