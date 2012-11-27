require File.expand_path('../lib/rest_connection', __FILE__)
require 'rake'
require 'spec/rake/spectask'

task :build do
  system "gem build rest_connection.gemspec"
end

task :release => :build do
  system "gem push rest_connection-#{RestConnection::VERSION}.gem"
end

Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = Dir.glob('spec/*_spec.rb')
  t.spec_opts << '--format nested'
  t.spec_opts << '--colour'
end
