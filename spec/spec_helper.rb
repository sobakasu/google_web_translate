require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end

require 'bundler/setup'
require 'webmock/rspec'
include WebMock::API

require 'google_web_translate'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture_read(path)
  File.read(File.join(__dir__, 'fixtures', path))
end

def test_http_headers
  { 'Accept' => '*/*',
    'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    'Host' => 'translate.google.com',
    'User-Agent' => GoogleWebTranslate::HTTPClient.user_agent }
end
