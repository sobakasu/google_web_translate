module GoogleWebTranslate
  class Server

    attr_reader :host

    class << self
      def urls
        File.readlines(File.join(__dir__, "urls.txt"))
        # TODO: Resolv.getaddress
        # discard duplicate ips
      end
    end

    def initialize(host)
    end

    def rate_limit_delay
      return 0 unless @last_request
      delay = @rate_limit - (Time.now - @last_request)
      (delay < 0 || ENV['TEST']) ? 0 : delay
    end
  end
end
