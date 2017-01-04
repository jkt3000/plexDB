require 'safe_attributes/base'

class MediaItem < ActiveRecord::Base
  include SafeAttributes::Base

  bad_attribute_names :hash, :size, :index

  has_many :media_parts
  belongs_to :libary_section
  belongs_to :metadata_item

  delegate :title, :year, :type, to: :metadata_item

  def width
    self[:width].to_i
  end

  def height
    self[:height].to_i
  end

  def bitrate
    "%.1f" % (attributes.fetch('bitrate').to_f / 1000000)
  end

end