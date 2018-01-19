RSpec.describe GoogleWebTranslate::API do
  it 'generates the correct token' do
    api = described_class.new(debug: ENV['DEBUG'])
    stub_responses(api)

    string = 'hello'
    expected_token = '550246.919607'
    token = api.send(:tk, string)
    expect(token).to eq(expected_token)
  end

  it 'returns data from the api' do
    api = described_class.new(debug: ENV['DEBUG'])
    stub_responses(api)

    string = 'right'
    from = 'en'
    to = 'de'

    result = api.translate(string, from, to)
    expect(result.translation).to eq('Recht')
    expect(result.alternatives).to eq(%w[Recht richtig rechts])
  end

  def stub_responses(api)
    html_response = fixture_read('main.html')
    json_response = fixture_read('single.json')
    desktop_js_response = fixture_read('desktop_module_main.js')

    # first request: gets main html
    response1 = stub_response(html_response)
    # second request: gets main desktop js
    response2 = stub_response(desktop_js_response)
    # third request: to google api
    response3 = stub_response(json_response)

    allow(api).to receive(:fetch_url_response)
      .and_return(response1, response2, response3)
  end

  def stub_response(response_body)
    response = double(:response)
    allow(response).to receive(:body).and_return(response_body)
    response
  end
end
