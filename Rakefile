require 'bundler/gem_tasks'
require 'json'
require 'pp'
require 'rake/testtask'
require 'selene'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
end

task :meetup do
  File.open('test/fixtures/meetup.json', 'wb') do |file|
    feed = Selene.parse(File.read('test/fixtures/meetup.ics'))
    pp feed
    file.write(JSON.pretty_generate(feed))
  end
end
