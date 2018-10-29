require_relative 'test_helper'

module BicFinder
  describe GermanBank do
    it 'knows where its remote source lives' do
      source_uri = URI.parse('https://www.bundesbank.de/resource/blob/602632/a44cbafa539a539be6222ffa06d33996/mL/blz-2018-09-03-txt-data.txt')
      assert_equal(GermanBank::REMOTE_SOURCE_URI, source_uri)
    end

    it 'knows where its cached data file lives' do
      data_file = File.join(BicFinder.configuration.cache_dir, 'de.txt')
      assert_equal(GermanBank.data_file, data_file)
    end

    describe 'self.update' do
      let(:data_file) { GermanBank.data_file }

      before do
        assert(File.file?(data_file))
        File.delete(data_file)
      end

      it 'updates its source' do
        VCR.use_cassette('download_de_source_file') do
          GermanBank.update
          assert(File.file?(data_file))
        end
      end
    end

    describe 'self.find_in_country' do
      it 'returns a bank' do
        bank = GermanBank.find_in_country('10000000')
        assert_instance_of(GermanBank, bank)
      end

      it 'finds the bank with the given bank code' do
        bank = GermanBank.find_in_country('10000000')
        assert_equal(bank.bic, 'MARKDEF1100')
      end

      it 'assigns the bank name' do
        bank = GermanBank.find_in_country('10000000')
        assert_equal(bank.name, 'Bundesbank')
      end

      it 'handles the file encoding' do
        bank = GermanBank.find_in_country('10030500')
        assert(bank.name.include?('Löbbecke'))
      end

      it 'returns nil when the bank code was not found' do
        assert_nil(GermanBank.find_in_country('00000000'))
      end
    end
  end
end
