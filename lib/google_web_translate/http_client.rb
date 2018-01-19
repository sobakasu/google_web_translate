require 'net/http'

module GoogleWebTranslate
  # HTTP client functionality
  class HTTPClient
    def self.user_agent
      gem_version = "GoogleWebTranslate/#{VERSION}"
      platform_version = "(#{RUBY_PLATFORM}) #{RUBY_ENGINE}/#{RUBY_VERSION}"
      gem_version + ' ' + platform_version
    end

    def initialize(options = {})
      @user_agent = options[:user_agent] || self.class.user_agent
    end

    def get(url)
      uri = URI.parse(url)
      request = Net::HTTP::Get.new(uri)
      request['User-Agent'] = @user_agent
      options = { use_ssl: uri.scheme == 'https' }
      Net::HTTP.start(uri.host, uri.port, options) do |http|
        http.request(request)
      end
    end
  end
end
