require_relative 'test_helper'

module BicFinder
  describe BelgianBank do
    it 'knows where its remote source lives' do
      source_uri = URI.parse('https://www.nbb.be/doc/be/be/protocol/current_codes.xlsx')
      assert_equal(BelgianBank::REMOTE_SOURCE_URI, source_uri)
    end

    it 'knows where its cached data file lives' do
      data_file = File.join(BicFinder.configuration.cache_dir, 'be.csv')
      assert_equal(BelgianBank.data_file, data_file)
    end

    describe 'self.update' do
      let(:data_file) { BelgianBank.data_file }

      before do
        assert(File.file?(data_file))
        File.delete(data_file)
      end

      it 'updates its source' do
        VCR.use_cassette('download_be_source_file') do
          BelgianBank.update
          assert(File.file?(data_file))
        end
      end
    end

    describe 'self.find_in_country' do
      it 'returns a bank' do
        bank = BelgianBank.find_in_country('000')
        assert_instance_of(BelgianBank, bank)
      end

      it 'finds the bank with the given bank code' do
        bank = BelgianBank.find_in_country('000')
        assert_equal(bank.bic, 'BPOT BE B1')
      end

      it 'assigns the bank name' do
        bank = BelgianBank.find_in_country('000')
        assert_equal(bank.name, 'bpost bank')
      end

      it 'handles the file encoding' do
        bank = BelgianBank.find_in_country('688')
        assert(bank.name.include?('Société'))
      end

      it 'returns nil when the bank code was not found' do
        assert_nil(BelgianBank.find_in_country('9999'))
      end
    end

    describe 'self.names' do
      it 'does not include missing languages' do
        bank = BelgianBank.find_in_country('000')
        refute_includes(bank.names.keys, :de)
      end
    end
  end
end
