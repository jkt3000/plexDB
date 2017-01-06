require 'safe_attributes/base'

class MediaItem < ActiveRecord::Base
  include SafeAttributes::Base

  bad_attribute_names :hash, :size, :index

  has_many :media_parts
  belongs_to :libary_section
  belongs_to :metadata_item
  
  # :file - absolute filename
  # :size - in bytes
  # :duration - in seconds

  delegate :title, :year, :type, to: :metadata_item


  def bitrate
    "%.1f" % (attributes.fetch('bitrate').to_f / 1000000)
  end

end