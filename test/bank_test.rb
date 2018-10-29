require_relative 'test_helper'

module BicFinder
  describe Bank do
    let(:bic)   { 'BIC001' }
    let(:names) { { en: 'MyBank', fr: 'MaBanque' } }
    let(:bank)  { Bank.new(bic, names) }

    describe 'self.update_all' do
      let(:austrian_data_file) { AustrianBank.data_file }
      let(:belgian_data_file)  { BelgianBank.data_file }
      let(:german_data_file)   { GermanBank.data_file }

      it 'updates all the bank sources' do
        VCR.use_cassette('download_all_source_files') do
          Bank.update_all
          assert(File.file?(austrian_data_file))
          assert(File.file?(belgian_data_file))
          assert(File.file?(german_data_file))
        end
      end
    end

    describe 'self.find_by_iban' do
      let(:belgian_iban) { 'BE68 5390 0754 7034' }
      let(:bank)         { Bank.find_by_iban(belgian_iban) }

      it 'returns a bank in the IBAN country' do
        assert_instance_of(BelgianBank, bank)
      end

      it 'finds the correct bank given the IBAN' do
        assert_equal(bank.bic, 'NAP')
      end
    end

    describe 'self.find' do
      let(:valid_bank_code)   { '000' }
      let(:invalid_bank_code) { '9999' }

      it 'returns a bank for the given country' do
        bank = Bank.find(valid_bank_code, 'BE')
        assert_instance_of(BelgianBank, bank)
      end

      it 'finds the Belgian bank with the given bank code' do
        bank = Bank.find(valid_bank_code, 'BE')
        assert_equal(bank.bic, 'BPOT BE B1')
      end

      it 'assigns the bank name' do
        bank = Bank.find(valid_bank_code, 'BE')
        assert_equal(bank.name, 'bpost bank')
      end

      it 'returns nil when the country is not supported' do
        assert_nil(Bank.find(valid_bank_code, 'ES'))
      end

      it 'returns nil when the bank code was not found' do
        assert_nil(Bank.find(invalid_bank_code, 'BE'))
      end
    end

    describe '#initialize' do
      it 'writes the BIC' do
        assert_equal(bank.instance_variable_get(:@bic), bic)
      end

      it 'writes a list of names in different languages' do
        assert_equal(bank.instance_variable_get(:@names), names)
      end
    end

    describe '#bic' do
      it 'gets the BIC' do
        assert_equal(bank.bic, bic)
      end
    end

    describe '#names' do
      it 'gets the names in all languages' do
        assert_equal(bank.names, names)
      end
    end

    describe '#name' do
      it 'gets a name in a specific language' do
        assert_equal(bank.name(locale: :fr), names[:fr])
      end

      it 'gets the first name if no language is specified' do
        assert_equal(bank.name, names[:en])
      end
    end
  end
end
