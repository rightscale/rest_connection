require File.expand_path('../lib/rest_connection/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'rest_connection'
  s.version      = RestConnection::VERSION
  s.platform     = Gem::Platform::RUBY
  s.date         = Time.now.utc.strftime("%Y-%m-%d")
  s.require_path = 'lib'
  s.authors      = [ 'RightScale, Inc.' ]
  s.email        = [ 'rubygems@rightscale.com' ]
  s.homepage     = 'https://github.com/rightscale/rest_connection'
  s.summary      = 'A Modular RESTful API library.'
  s.description  = %{
This gem is deprecated! Please use right_api_client instead.
The rest_connection gem simplifies the use of RESTful APIs.
It currently has support for RightScale API 1.0 and 1.5.
  }
  s.files = `git ls-files`.split(' ')
  s.test_files = `git ls-files spec config`.split(' ')
  s.rubygems_version = '1.8.24'

  s.add_runtime_dependency 'net-ssh'
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'highline'
  s.add_runtime_dependency 'rest-client'

  s.add_development_dependency 'rake',         '0.8.7'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec',        '1.3.0'
  # If we're using Ruby 1.9.x
  if RUBY_VERSION =~ /1.9.*/
    s.add_runtime_dependency 'activesupport'
    s.add_runtime_dependency 'nokogiri'
    s.add_development_dependency 'ruby-debug19'
  elsif RUBY_VERSION =~ /1.8.*/
    # Ruby 1.8.x needs limited nokogiri version
    s.add_runtime_dependency 'nokogiri', "<1.6.0"
    # Ruby 1.8.x needs limited activesupport version
    s.add_runtime_dependency 'activesupport', "<4.0.0"
    s.add_development_dependency 'ruby-debug'
  else
    raise "Ruby version '#{RUBY_VERSION}' is not currently supported."
  end
end
