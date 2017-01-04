# PlexDB

PlexDB is a gem and CLI tool for accessing and using your Plex DB to rename your source files.

The CLI allows you to provide a file or directory, and the app will lookup the filename in the Plex database, and rename the file and directory based on a filename template.

For example:

    plex rename The.Martian.1080p.AAC5.1-bluray.mp4

It will find the Plex entry associated with this file, and then rename the file as:

    /The Martian (2015) [1080p]/The Martian (2015) [1080p].mp4


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'plexDB'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install plexDB

Copy your Plex DB to a suitable location (for now, you can't use the production database while Plex is running)

Set up your config file ```~/.plexDB_config.yml``` as noted below


## Usage

    plexdb <command> 

To rename a file or a directory of files

    plex rename /path/of/movies <options>

This will go through each file in the directory and find which ones are movies/tv shows, and preview the changes it will make. You will need to confirm each change, otherwise you can force override by supplying a ```-f``` option.

    plex rename /path/filename <options>

If you supply a filename, it will process just that single file. By default, since files are put into their own folder, a new folder will be created and the file moved into that location.


#### options
```
-f, --force     force change - do not wait for verification/confirmation, just make the changes
-p, --preview   don't make change, just print out what action will be taken
```

See ```plex help rename``` for all the possible options.

## Configuration 

Create a default conf file in ```~/.plexDB_config.yml```

The basic should contain at least the absolute path location to your plex db.

```
database: /path/to/plex.db
```

You can also add custom filename templates for movies and tv shows.

```
movie_template: <your custom liquid template string for movies>
tv_template: <your custom liquid template string for tv shows>
```

## Templates

By default the templates for movies and TV shows are defined as shown below. It uses Shopify's Liquid template language.

#### Default Movie template:

```
{{title}} ({{year}}) [{{resolution}}]{% if comments -%}[{{comments}}]{% endif %}/{{title}} ({{year}}) [{{resolution}}]{% if comments -%}[{{comments}}]{% endif %}.{{ext}}
```

eg: ```The Martin (2015) [1080p] [Extended]/The Martin (2015) [1080p] [Extended].mkv```

#### Default TV template:

```
{{title}} S{{season}}/{{title}} S{{season}}E{{episode}} [{{resolution}}].{{ext}}
```

eg:  ```/True Detective S01/True Detective S01E02 [480p].avi```


## Notes

I wrote this because I wanted a way to update my files based on the data from the Plex database. I couldn't find any information about the Plex API that would allow me to find an entry based on the name of the file - most of the APIs allowed lookup based on a movie name, etc.

Currently the process is a little cumbersome, as you have to use a copy of the plex db (or a backup version) - I still haven't found a way to read the actual production database. It seems like it's locked. I'll need to find a way to read or copy the db without shutting down plex. It is complicated for my use case as my plex db is on a remote machine and I actually just mount my movies and tv folders.

## To do

- find a way to use production database without having to shutdown Plex Server or use a backup database copied to a specific folder
- better/cleaner logging
- ability to clean filenames of subtitle files
- find an API to search for Plex entries based on filename (this would remove the need to do the whole read the SQL database, and get rid of all the activerecord models)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/plexDB.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

