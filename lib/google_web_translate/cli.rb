require 'thor'
require 'pp'

module GoogleWebTranslate
  # Command line interface
  class CLI < Thor
    desc 'string from to', 'translate a string from one language to another'
    method_option :dt, type: :array, desc: 'data types'
    def translate(string, from, to)
      api_options = { debug: ENV['DEBUG'] }
      api_options[:dt] = options[:dt] if options[:dt]

      api = API.new(api_options)
      result = api.translate(string, from, to)
      pp result.to_h
    end
  end
end
