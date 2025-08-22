require 'open-uri'

module BicFinder
  class GermanBank < Bank
    # German bank sort codes found via https://www.bundesbank.de/en/tasks/payment-systems/services/bank-sort-codes/
    REMOTE_SOURCE_URI = URI.parse('https://www.bundesbank.de/resource/blob/602632/a44cbafa539a539be6222ffa06d33996/mL/blz-2018-09-03-txt-data.txt').freeze
    SOURCE_CHECKSUM = 'f1019826abdc9872195db7db65f898fe'.freeze

    # Updates or creates a locally cached TXT
    # file with the German bank sort codes.
    def self.update
      io = URI.open(REMOTE_SOURCE_URI, 'rb')
      io.close
      FileUtils.mv(io.path, data_file)
    end

    # Finds the bank's BIC and name in the locally
    # cached TXT file from the provided bank code.
    def self.find_in_country(bank_code)
      File.open(data_file, 'r:iso-8859-1').each_line do |line|
        next if bank_code.to_i != line[0..7].to_i

        bic = line[139..149].strip
        name = line[9..66].encode('utf-8').strip
        names = { de: name }
        return new(bic, names)
      end
      nil
    end

    def self.data_file
      File.join(BicFinder.configuration.cache_dir, 'de.txt')
    end
  end
end
