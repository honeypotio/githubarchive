require 'rubygems'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

require_relative '../githubarchive'

RSpec.describe Githubarchive do
  let(:db_url) { 'postgres://postgres:postgres@localhost:5432/githubarchive_test' }
  let(:db) { Sequel.connect(db_url) }
  let(:storage) { described_class::Database.new(db_url) }
  let(:filter) { Proc.new {|event| !(event['type'] == 'PullRequestEvent' && event['payload']['action'] == 'opened')}}

  let(:archive_url) { 'http://data.githubarchive.org/2015-01-01-12.json.gz' }

  it 'dowloads and inserts data into db' do
    VCR.use_cassette("githubarchive_2015010112") do
      expect {
        described_class.new(filter: filter, procesor: storage).call(archive_url)
      }.to change{ db[:events].count }.by(189)
    end
  end

  describe '#to_links' do
    it 'returns archive links for time' do
      expect(subject.to_links(Time.parse('2015-01-01 12:22:26'))).to eq(
        [archive_url]
      )
    end

    it 'returns multiple for range' do
      expect(
        subject.to_links(Time.parse('2015-01-01 12:22:26'), Time.parse('2015-01-01 13:22:26'))
      ).to eq(
        [archive_url, archive_url.sub('12', '13')]
      )
    end
  end
end
