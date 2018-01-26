source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

def gem_installed?(args)
  name, *version = *args
  dependency = Gem::Dependency.new(name, *version)
  specs = dependency.matching_specs
  specs && !specs.empty?
end

def optional_gem(*args)
  gem(*args) if gem_installed?(args)
end

# database adapters
optional_gem 'therubyracer', platform: :ruby
optional_gem 'therubyrhino', platform: :jruby

# optional c extensions
optional_gem 'concurrent-ruby-ext', platform: :ruby

# Specify your gem's dependencies in google-web-translate.gemspec
gemspec
