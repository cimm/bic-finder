require 'bic-finder'
require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/spec'
require 'tmpdir'
require 'vcr'
require 'webmock/minitest'
require 'fileutils'

TEST_CACHE_DIR = File.join(Dir.tmpdir, "bic-finder-tests-#{srand}").freeze
FIXTURES_PATH = File.join(File.dirname(__FILE__), 'fixtures').freeze

BicFinder.configuration.cache_dir = TEST_CACHE_DIR
Dir.mkdir(TEST_CACHE_DIR)

# Cleanup source files after build
Minitest.after_run do
  FileUtils.rm_r(TEST_CACHE_DIR)
end

VCR.configure do |config|
  config.cassette_library_dir = File.join(FIXTURES_PATH, 'cassettes')
  config.hook_into :webmock
end

# Download all source files (from the fixtures) before build
VCR.use_cassette('download_all_source_files') do
  BicFinder::Bank.update_all
end
