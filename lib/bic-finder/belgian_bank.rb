require 'csv'
require 'open-uri'
require 'roo'

module BicFinder
  class BelgianBank < Bank
    REMOTE_SOURCE_URI = URI.parse('https://www.nbb.be/doc/be/be/protocol/current_codes.xlsx').freeze
    SOURCE_CHECKSUM = '8478dabe8f90f1d643dc7e70f77a88d3'.freeze
    CSV_OPTIONS = { skip_lines: /^\"version/, headers: true, skip_blanks: true }.freeze

    # Updates or creates a locally cached CSV file with all Belgian IBAN
    # mappings by downloading the Excel file from the National Bank's website.
    def self.update
      io = open(REMOTE_SOURCE_URI, 'rb')
      xlsx = Roo::Spreadsheet.open(io.path, extension: :xlsx)
      body = xlsx.sheet(0).to_csv
      File.open(data_file, 'wb') { |file| file.write(body) }
    end

    # Finds the bank's BIC and multi-lingual name in the locally
    # cached CSV file from the provided bank code.
    def self.find_in_country(bank_code)
      CSV.foreach(data_file, CSV_OPTIONS) do |row|
        next unless bank_code.to_i.between?(row['From'].to_i, row['To'].to_i)

        bic = row['Biccode']
        names = {}
        names[:en] = row['Name English'] if row['Name English']
        names[:nl] = row['Name Dutch']   if row['Name Dutch']
        names[:fr] = row['Name French']  if row['Name French']
        names[:de] = row['Name German']  if row['Name German']
        return new(bic, names)
      end
    end

    def self.data_file
      File.join(BicFinder.configuration.cache_dir, 'be.csv')
    end
  end
end
