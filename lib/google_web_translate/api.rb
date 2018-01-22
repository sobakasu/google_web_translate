require 'execjs'
require 'json'

module GoogleWebTranslate
  # interface to the google web translation api
  class API
    def initialize(options = {})
      @dt = options[:dt] || DEFAULT_DT
      @token_ttl = options[:token_ttl] || DEFAULT_TOKEN_TTL
      @debug = options[:debug]
      @http_client = options[:http_client] || HTTPClient.new(options)
    end

    def translate(string, from, to)
      data = fetch_translation(string, from, to)
      Result.new(data)
    end

    private

    URL_MAIN = 'https://translate.google.com'.freeze
    URL_TRANSLATE_1 = URL_MAIN + '/translate_a/single'.freeze
    DEFAULT_DT = %w[at bd ex ld md qca rw rm ss t].freeze
    DEFAULT_TOKEN_TTL = 3600

    def fetch_translation(string, from, to)
      json = fetch_url_body(translate_url(string, from, to))
      # File.open("response.json", "w") { |f| f.puts json }
      JSON.parse(json)
    end

    def fetch_url_response(url)
      @http_client.get(url.to_s)
    end

    def fetch_url_body(url)
      uri = URI.parse(url)
      uri = URI.join(URL_MAIN, url) if uri.relative?
      debug("fetch #{uri}")
      response = fetch_url_response(uri)
      # debug("response: #{response.body}")
      response.body
    end

    def valid_token?
      @token_updated_at && Time.now - @token_updated_at < @token_ttl
    end

    def fetch_main
      fetch_url_body(URL_MAIN)
    end

    def fetch_desktop_module(html)
      html =~ /([^="]*desktop_module_main.js)/
      url = Regexp.last_match(1)
      raise 'unable to find desktop module' unless url
      fetch_url_body(url)
    end

    def munge_module(js)
      js.gsub(/((?:var\s+)?\w+\s*=\s*\w+\.createElement.*?;)/) do |_i|
        'return "";'
      end
    end

    def compile_js(html)
      desktop_module_js = munge_module(fetch_desktop_module(html))
      window_js = File.read(File.join(__dir__, '..', 'js', 'window.js'))
      js = window_js + desktop_module_js
      File.open('generated.js', 'w') { |f| f.puts(js) } if debug?
      ExecJS.compile(js)
    end

    def update_token
      # download main page
      html = fetch_main
      # extract tkk from html
      @tkk = extract_tkk(html)
      # compile desktop module javascript
      @js_context = compile_js(html)
      @token_updated_at = Time.now
    end

    def tk(string)
      update_token unless valid_token?
      @js_context.call('setWindowProperty', 'TKK', @tkk)
      # tk = @js_context.call("wq", string)
      tk = @js_context.call('generateToken', string, @tkk)
      (tk.split('=') || [])[1]
    end

    def tk_js
      File.read(File.join(__dir__, 'google_web.js'))
    end

    def extract_tkk(html)
      raise 'TKK not found' unless html =~ /TKK=eval\('(.*?)'\);/
      tkk_code = Regexp.last_match(1)
      # tkk_code = Translatomatic::StringEscaping.unescape(tkk_code)
      tkk_code = StringEscaping.unescape(tkk_code)
      debug("tkk code unescaped: #{tkk_code}")
      tkk = ExecJS.eval(tkk_code)
      #tkk = context.call(nil)
      debug("evaluated tkk: #{tkk}")
      tkk
    end

    def translate_url(string, from, to)
      tk = tk(string)
      debug("tk: #{tk}")
      query = {
        sl: from, tl: to, ie: 'UTF-8', oe: 'UTF-8',
        q: string, dt: @dt, tk: tk,
        # not sure what these are for
        client: 't', hl: 'en', otf: 1, ssel: 4, tsel: 6, kc: 5
      }
      url = URI.parse(URL_TRANSLATE_1)
      url.query = URI.encode_www_form(query)
      url.to_s
    end

    def debug(msg)
      puts msg if debug?
    end

    def debug?
      @debug
    end
  end
end
