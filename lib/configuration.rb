require 'tmpdir'

module BicFinder
  class Configuration
    attr_accessor :cache_dir

    def initialize
      @cache_dir = Dir.tmpdir
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
