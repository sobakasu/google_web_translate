require 'concurrent'
require 'resolv'
require 'json'

module GoogleWebTranslate
  # @private
  SERVER_ATTRIBUTES = %i[host ip resolved_at last_used_at
                         counter available].freeze

  Server = Struct.new(*SERVER_ATTRIBUTES) do
    def to_json(*args)
      result = {}
      each_pair { |key, value| result[key] = value }
      result.to_json(args)
    end
  end

  class ServerList
    class << self
      def servers
        update_servers if @servers.nil?
        @servers.dup
      end

      def next_server(rate_limit = nil)
        @mutex ||= Mutex.new
        @mutex.synchronize do
          @counter ||= 0
          @counter += 1

          list = servers.sort_by { |i| i.counter || 0 }
          server = list[0]
          server.counter = @counter
          sleep(rate_limit_delay(server, rate_limit))
          server.last_used_at = Time.now
          server
        end
      end

      private

      MAX_TTL = 86_400

      def rate_limit_delay(server, rate_limit)
        return 0 unless rate_limit && server.last_used_at
        delay = rate_limit - (Time.now - server.last_used_at)
        (delay < 0 || ENV['TEST']) ? 0 : delay
      end

      def update_servers
        server_list = read_server_data
        pool = Concurrent::CachedThreadPool.new
        # puts "updating #{server_list.length} servers"
        server_list.each do |server|
          pool.post { update_server(server) }
        end

        pool.shutdown
        pool.wait_for_termination
        @servers = unique_servers(server_list)
        # puts "#{@servers.length} unique servers found"
        save_server_data(server_list)
      end

      def update_server(server)
        now = Time.now.to_i
        if server.resolved_at.nil? ||
           now - server.resolved_at > MAX_TTL || !server.available
          server.resolved_at = now
          server.ip = resolve_ip(server.host)
        end
        server.available = true
      rescue Resolv::ResolvError
        # puts "server #{server.host} is unavailable: #{e}"
        server.available = false
      end

      def data_dir
        File.join(__dir__, '..', '..', 'data')
      end

      def server_data_path
        File.join(data_dir, 'server_data.txt')
      end

      def url_list_path
        File.join(data_dir, 'urls.txt')
      end

      def hostnames
        names = []
        lines = File.read(url_list_path).split(/[\r\n]+/)
        lines.each do |host|
          next unless host && !host.empty?
          names << "translate.#{host}"
        end
        names
      end

      def unique_servers(list)
        server_by_ip = {}
        list.each do |server|
          next unless server.available
          server_by_ip[server.ip] = server
        end
        server_by_ip.values
      end

      def initial_data
        hostnames.collect do |host|
          server = Server.new
          server.host = host
          server
        end
      end

      def read_server_data
        return initial_data unless File.exist?(server_data_path)
        data = JSON.parse(File.read(server_data_path))
        server_list = []
        data.each do |entry|
          attributes = SERVER_ATTRIBUTES.collect { |i| entry[i.to_s] }
          server = Server.new(*attributes)
          next unless server.host && !server.host.empty?
          server.counter = 0
          server_list << server
        end
        server_list
      end

      def save_server_data(servers)
        File.write(server_data_path, servers.to_json)
      end

      def resolver
        resolver = Resolv::DNS.new
        resolver.timeouts = 5
        resolver
      end

      def resolve_ip(host)
        resolver.getaddress(host).to_s
      end
    end
  end
end
