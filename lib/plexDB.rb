$LOAD_PATH.unshift File.dirname(__FILE__)

require 'yaml'
require 'sqlite3'
require 'active_record'
require 'active_support'
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

end
