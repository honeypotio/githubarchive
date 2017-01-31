#!/usr/bin/env ruby

require_relative '../githubarchive'

storage = Githubarchive::Database.new(ENV['DATABASE_URL'])

# required if you want to import filtered events
filter = Proc.new do |event|
  !(event['type'] == 'PullRequestEvent' && event['payload']['action'] == 'opened')
end

archive = Githubarchive.new(filter: filter, procesor: storage)

# create events table if not present
# storage.create_table

# generate archive links from start, end times
archive_links = archive.to_links(
  Time.parse('2016-01-27 00:00:00'),
  Time.parse('2016-01-27 23:59:59')
)

thread_count = ENV['THREAD_COUNT'] || 3

archive_links.in_groups(thread_count, false) do |links|
  Thread.new do
    storage_l = Githubarchive::Database.new(ENV['DATABASE_URL'])
    Githubarchive.new(filter: filter, procesor: storage_l).call(links)
  end
end
