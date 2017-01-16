# Githubarchive

Your own, queryable [github archive][1] database creator

## Introduction

If you have had the desire to find out what repositories
a github user started watching, which issues he/she commented
on, what repositories|gists|issues he/she created ...

And you want to know this information not only for the last 3
months, but all back to January 2015 [githubarchives.org][1] is
there to help as it contains gzipped archives for every day/hour
of github event activity all back to January 2015.

### So why this project?

githubarchives.org provides you with TB's of archived json files
so it might take some time to find your desired information there
without some tooling.

All of this data is loaded into a public dataset on [Google BigQuery][2]
so it is easily queryable by anyone with SQL like syntax and blazing speed!

But be aware that it might be too costly for you. BigQuery Free Tier and
On-Demand plans are charging per TB of data processed. 1 TB a month for
free and $5 per every TB afterwards.

With couple of queries for my own gihtub history I quickly managed to
get my invoice up to $40 and [thats not much][5] so please be sure you
read and understand the [BigQuery pricing][4].

In case you don't really need the full capabilities of BigQuery but you
would still like to query the data frequently this project helps
to import the archive (or at least a subset of it) into your own
Postgres database.

## Importing data

```shell
# Clone repository:
git clone git@github.com:honeypotio/githubarchive.git

# install dependencies
cd githubarchive
bundle install

# create test database
./script/create_test_db

# verify it works
rspec spec

# set the target database
export DATABASE_URL='postgres://user:password@host:port/database'

# start irb
irb -r ./githubarchive.rb
```

```irb
storage = Githubarchive::Database.new(ENV['DATABASE_URL'])

# required if you want to import filtered events
filter = Proc.new { |e| e['type'] != 'PullRequestEvent' }

archive = Githubarchive.new(filter: filter, procesor: storage)

# create events table if not present
storage.create_table

# generate archive links from start, end times
archive_links = archive.to_links(
  Time.parse('2016-01-01 00:00:00'),
  Time.parse('2016-01-01 23:59:59')
)

archive.call(archive_links)
```

## Setup


License
-------

Copyright © 2017 [Honeypot GmbH][3]. It is free software, and may be
redistributed under the terms specified in the [LICENSE](/LICENSE) file.

About Honeypot
--------------

[![Honeypot](https://www.honeypot.io/logo.png)][3]

Honeypot is a developer focused job platform.
The names and logos for Honeypot are trademarks of Honeypot GmbH.

[1]: https://www.githubarchive.org
[2]: https://cloud.google.com/bigquery
[3]: https://www.honeypot.io?utm_source=github
[4]: https://cloud.google.com/bigquery/pricing
[5]: http://stackoverflow.com/questions/18834196/google-bigquery-pricing
