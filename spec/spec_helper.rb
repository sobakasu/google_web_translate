require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end

require 'bundler/setup'
# require 'webmock/rspec'
# include WebMock::API

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
  { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate',
    'Host' => 'translate.google.com',
    'User-Agent' => 'rest-client/2.0.2 (darwin17.3.0 x86_64) ruby/2.4.1p111' }
end
