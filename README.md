# PlexDB

PlexDB is a gem and CLI tool for accessing and using your Plex DB.
In particular, the MVP is to provide a CLI tool to help rename your files into a standard format based on the data in the Plex DB.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'plexDB'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install plexDB

## Usage

> plexdb <command> 

To rename a file/files

> plex rename /path/of/movies <options>

eg: > plex rename /mymovies 

This will go through each movie file/path found in /mymovies and preview what changes will be made, and ask for verification before changing.

#### options
```
--force     force change - do not wait for verification/confirmation, just make the changes
--preview   don't make change, just print out what action will be taken
```

## Configuration 

Create a default conf file in ~/.plexdb_conf.yml

The basic should contain at least the absolute path location to your plex db.

```
database: /path/to/plex.db
```

You can also add custom filename templates for movies and tv shows.

```
movie_template: <your custom liquid template string for movies>
tv_template: <your custom liquid template string for tv shows>
```

#### Default Movie template:
```
/{{title}} ({{year}}) [{{resolution}}|{{sound}}] {% if comments -%}[{{comments}}]{% end %}/{{title}} ({{year}}) [{{resolution}}|{{sound}}] {% if comments -%}[{{comments}}]{% end %}.{{ext}}
```
eg: ```The Martin (2015) [1080p] [Extended]/The Martin (2015) [1080p] [Extended].mkv```


#### Default TV template:

True Detective S01/True Detective S01E01 [480p].avi

```/{{title}} S{{season}}/{{title}} S{{season}}E{{episode}} [{{resolution}}|{{sound}}.{{ext}}```

eg:  ```/True Detective S01/True Detective S01E02 [480p].avi```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/plexDB.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


# notes

To grab details of the TV show, given a metadata_item,
the season is where the metadata_item = MetadataItem.where(id: metadata_item.parent_id, metadata_type: 3), metadata_item.index is the season #
name of the show is the season's metadata_item.parent_id and type = 2

metadata.type  1 - movie? 
              2  - show? 3 - season, 4 is episode?
