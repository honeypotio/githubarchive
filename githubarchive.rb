require 'open-uri'
require 'zlib'
require 'yajl'

class Githubarchive
  BASE_URL = 'http://data.githubarchive.org/'
  FILE_EXT = '.json.gz'
  TIME_PATTERN = '%Y-%m-%d-%H'


  def initialize(procesor: Proc.new {|event| print event }, filter: ->(_e) { false })
    @procesor = procesor
    @filter = filter
  end

  def call(*urls)
    urls.flatten.each do |url|
      gz = open(url)
      js = Zlib::GzipReader.new(gz).read

      Yajl::Parser.parse(js, &method(:consumer))
    end
  end

  def to_archive_links(start_time, end_time=nil)
    time_hour_iterate(start_time, end_time || start_time).map do |time|
      BASE_URL + time.strftime(TIME_PATTERN) + FILE_EXT
    end
  end

  private

  attr_reader :procesor, :filter

  def consumer(event)
    unless filter.call(event)
      procesor.call(event)
    end
  end

  def time_hour_iterate(start_time, end_time, acc=[])
    begin
      acc << start_time
    end while (start_time += 3600) <= end_time
    acc
  end

  require 'sequel'
  require 'pg'

  class Database
    def initialize(url)
      @database = Sequel.connect(url).tap{|db| db.extension :pg_array, :pg_json}
    end

    def call(event)
      event['payload'] = Sequel.pg_json(event['payload']) if event['payload']
      event['repo'] = Sequel.pg_json(event['repo']) if event['repo']
      event['actor'] = Sequel.pg_json(event['actor']) if event['actor']
      event['org'] = Sequel.pg_json(event['org']) if event['org']
      event['other'] = Sequel.pg_json(event['other']) if event['other']
      events.insert(event)
    end

    def create
      add_uuid_extensin
      database.create_table :events do
        column :uuid, :uuid, default: Sequel.function(:uuid_generate_v4), primary_key: true
        String :type
        Boolean :public
        column :payload, :jsonb
        column :repo, :json
        column :actor, :json
        column :org, :json
        DateTime :created_at
        String :id
        column :other, :json
      end
    end

    def drop
      database.drop_table :events
    end

    private

    attr_reader :database

    def events
      database[:events]
    end

    def add_uuid_extensin
      database.run('CREATE EXTENSION "uuid-ossp"')
    end
  end
end

