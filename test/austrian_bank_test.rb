require_relative 'test_helper'

module BicFinder
  describe AustrianBank do
    it 'knows where its remote source lives' do
      source_uri = URI.parse('https://www.oenb.at/idakilz/kiverzeichnis?action=downloadAllData')
      assert_equal(AustrianBank::REMOTE_SOURCE_URI, source_uri)
    end

    it 'knows where its cached data file lives' do
      data_file = File.join(BicFinder.configuration.cache_dir, 'at.csv')
      assert_equal(AustrianBank.data_file, data_file)
    end

    describe 'self.update' do
      let(:data_file) { AustrianBank.data_file }

      before do
        assert(File.file?(data_file))
        File.delete(data_file)
      end

      it 'updates its source' do
        VCR.use_cassette('download_at_source_file') do
          AustrianBank.update
          assert(File.file?(data_file))
        end
      end
    end

    describe 'self.find_in_country' do
      it 'returns a bank' do
        bank = AustrianBank.find_in_country('52300')
        assert_instance_of(AustrianBank, bank)
      end

      it 'finds the bank with the given bank code' do
        bank = AustrianBank.find_in_country('52300')
        assert_equal(bank.bic, 'HSEEAT2KXXX')
      end

      it 'assigns the bank name' do
        bank = AustrianBank.find_in_country('52300')
        assert_equal(bank.name, 'Addiko Bank AG')
      end

      it 'handles the file encoding' do
        bank = AustrianBank.find_in_country('20320')
        assert(bank.name.include?('Oberösterreich'))
      end

      it 'returns nil when the bank code was not found' do
        assert_nil(AustrianBank.find_in_country('00000'))
      end
    end
  end
end
