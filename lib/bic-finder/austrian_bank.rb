require 'open-uri'
require 'smarter_csv'
require 'zip'

module BicFinder
  class AustrianBank < Bank
    REMOTE_SOURCE_URI = URI.parse('https://www.oenb.at/idakilz/kiverzeichnis?action=downloadAllData').freeze
    SOURCE_CHECKSUM = '4a49b77917edd955b72fd1c905a0a35f'.freeze
    CSV_OPTIONS = { col_sep: ';', skip_lines: 5 }.freeze

    # Updates or creates a locally cached CSV file with all Austrian IBAN
    # mappings by downloading the ZIP file from the Nationalbank's website.
    def self.update
      io = open(REMOTE_SOURCE_URI, 'rb')
      Zip::File.open(io) do |zip_file|
        entry = zip_file.glob('*.csv').first
        stream = entry.get_input_stream
        File.open(data_file, 'w') do |file|
          file.write(stream.read.force_encoding('iso-8859-1').encode('utf-8'))
        end
      end
      io.close
    end

    # Finds the bank's BIC and multi-lingual name in the locally
    # cached CSV file from the provided bank code.
    def self.find_in_country(bank_code)
      # Using SmarterCSV here since the source file is badly formatted
      SmarterCSV.process(data_file, CSV_OPTIONS).each do |row|
        next if bank_code != row[:bankleitzahl].to_s

        bic = row[:swift_code]
        name = row[:bankenname]
        names = { de: name }
        return new(bic, names)
      end
      nil
    end

    def self.data_file
      File.join(BicFinder.configuration.cache_dir, 'at.csv')
    end
  end
end
