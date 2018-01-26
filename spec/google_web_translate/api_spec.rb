RSpec.describe GoogleWebTranslate::API do
  it 'generates the correct token' do
    # this test only works with fixture data
    skip('unknown token for live network test') if allow_net_connections?

    api = described_class.new(debug: ENV['DEBUG'])
    stub_requests

    string = 'hello'
    expected_token = '64319.431761'
    token = api.send(:tk, string)
    expect(token).to eq(expected_token)
  end

  it 'translates a string' do
    api = described_class.new(debug: ENV['DEBUG'])
    stub_requests

    string = 'right'
    from = 'en'
    to = 'de'

    result = api.translate(string, from, to)
    expect(result.translation).to eq('Recht')
    expect(result.alternatives).to eq(%w[Recht richtig rechts])
  end

  it 'translates two strings' do
    api = described_class.new(debug: ENV['DEBUG'])
    stub_requests

    strings = ['right', 'right']
    from = 'en'
    to = 'de'

    strings.each do |string|
      result = api.translate(string, from, to)
      expect(result.translation).to eq('Recht')
      expect(result.alternatives).to eq(%w[Recht richtig rechts])
    end
  end

  it 'returns a list of supported languages' do
    api = described_class.new(debug: ENV['DEBUG'])
    stub_requests

    result = api.languages
    expect(result).to eq(["af", "am", "ar", "az", "be", "bg", "bn", "bs", "ca", "co", "cs", "cy", "da", "de", "el", "en", "eo", "es", "et", "eu", "fa", "fi", "fr", "fy", "ga", "gd", "gl", "gu", "ha", "hi", "hr", "ht", "hu", "hy", "id", "ig", "is", "it", "iw", "ja", "jw", "ka", "kk", "km", "kn", "ko", "ku", "ky", "la", "lb", "lo", "lt", "lv", "mg", "mi", "mk", "ml", "mn", "mr", "ms", "mt", "my", "ne", "nl", "no", "ny", "or", "pa", "pl", "ps", "pt", "ro", "ru", "rw", "sd", "si", "sk", "sl", "sm", "sn", "so", "sq", "sr", "st", "su", "sv", "sw", "ta", "te", "tg", "th", "tk", "tl", "tr", "tt", "ug", "uk", "ur", "uz", "vi", "xh", "yi", "yo", "zh", "zu"])
  end

  def stub_requests
    if allow_net_connections?
      WebMock.allow_net_connect!
      return
    end

    html_response = fixture_read('main.html')
    json_response = fixture_read('single.json')
    desktop_js_response = fixture_read('desktop_module_main.js')

    # first request: gets main html
    stub_url_request(described_class::URL_MAIN, html_response)
    # second request: gets main desktop js
    stub_url_request(/desktop_module_main.js/, desktop_js_response)
    # third request: to google api
    stub_url_request(/translate_a/, json_response)
  end

  def stub_url_request(url, response_body)
    stub_request(:get, url)
      .with(headers: test_http_headers)
      .to_return(status: 200, body: response_body, headers: {})
  end
end
