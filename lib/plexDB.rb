$LOAD_PATH.unshift File.dirname(__FILE__)

require 'yaml'
require 'sqlite3'
require 'active_record'
require 'active_support'
require 'liquid'
require "plexDB/version"
Dir["./lib/plexDB/models/*"].each {|file| require file }

module PlexDB
  # Your code goes here...
  CONFIG_FILE    = "~/.plexDB_config.yml"
  DEFAULT_CONFIG = "./config/plexDB.yml"

  SETTINGS = begin
    default_config = YAML.load(File.open(DEFAULT_CONFIG).read)
    custom_config = if File.exists?(File.expand_path(CONFIG_FILE))
      YAML.load(File.open(File.expand_path(CONFIG_FILE)).read)
    else
      {}
    end
    default_config.merge(custom_config)
  end

  raise StandardError, "Database not defined in ~/.plexDB_config.yml" if SETTINGS['database'].blank?

  ActiveRecord::Base.establish_connection({
    :adapter  => 'sqlite3',
    :database => SETTINGS['database']
  })

  extend self

  def find_by_title(title)
    return nil unless result = MetadataItem.where(title: title)
    result
  end

  def find_by_filename(filename)
    result = MediaPart.where("file like ?", "%#{filename}").first
    PlexModel.create_from_media_part(result) if result
  end

  def tv_template
    @tv_template ||= Liquid::Template.parse(SETTINGS['tv_template'])
  end

  def movie_template
    @movie_template ||= Liquid::Template.parse(SETTINGS['movie_template'])
  end

end
