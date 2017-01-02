$LOAD_PATH.unshift File.dirname(__FILE__)

require 'yaml'
require 'sqlite3'
require 'active_record'
require 'active_support'
require 'active_support/core_ext/numeric'
require 'liquid'
require "plexDB/version"
require 'plexDB/templates'
require 'plexDB/renamer'
Dir[File.join(File.dirname(__FILE__), "plexDB/models/*")].each {|file| require_relative file }

module PlexDB

  CONFIG_FILE    = "~/.plexDB_config.yml"
  DEFAULT_CONFIG = File.join(File.dirname(__FILE__), "../config/plexDB.yml")
  SETTINGS       = begin
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
end
