
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google_web_translate/version'

Gem::Specification.new do |spec|
  spec.name          = 'google_web_translate'
  spec.version       = GoogleWebTranslate::VERSION
  spec.authors       = ['Andrew']
  spec.email         = ['sobakasu@gmail.com']

  spec.summary       = 'Text translation using the google web interface'
  spec.homepage      = 'https://github.com/sobakasu/google_web_translate'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = %w[google_web_translate]
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'

  spec.add_dependency 'execjs'
  spec.add_dependency 'thor'
end
