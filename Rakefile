require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
end

task :meetup do
  require 'selene'
  require 'json'
  require 'pp'

  File.open('test/fixtures/meetup.json', 'wb') do |file|
    feed = Selene.parse(File.read('test/fixtures/meetup.ics'))
    pp feed
    file.write(feed.to_json)
  end
end
