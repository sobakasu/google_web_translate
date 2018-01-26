RSpec.describe GoogleWebTranslate::ServerList do
  context '#servers' do
    it 'returns a list of servers' do
      servers = server_list
      #p servers
      expect(servers).to be
      expect(servers.length).to be > 1
    end
  end

  context '#next_server' do
    it 'cycles through all available servers' do
      count = server_list.length
      last_server = nil
      (count * 2).times do
        server = next_server
        #puts "server: #{server}"
        expect(server).to be
        if last_server
          expect(server.ip).to_not eq(last_server.ip)
        end
        last_server = server
      end
    end

    it 'delays according to a rate limit' do
      count = server_list.length
      count.times { next_server }
      now = Time.now
      expected_delay = 3
      next_server(expected_delay)
      actual_delay = (Time.now - now).to_i
      expect(actual_delay).to eq(expected_delay)
    end
  end

  def server_list
    described_class.servers
  end

  def next_server(rate_limit = nil)
    described_class.next_server(rate_limit)
  end
end
