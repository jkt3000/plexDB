# media_items
# :id
# :library_section_id
# :section_location_id
# :metadata_item_id
# :type_id
# :width
# :height
# :size
# :duration
# :bitrate
# :container
# :video_codec
# :audio_codec
# :display_aspect_ratio
# :frames_per_second
# :audio_channels
# :interlaced
# :source
# :hints
# :display_offset
# :settings
# :created_at
# :updated_at
# :optimized_for_streaming
# :deleted_at
# :media_analysis_version
# :sample_aspect_ratio
# :extra_data
# :proxy_type

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


  def dimension
    "#{width}x#{height}"
  end

  def bitrate
    "%.1f" % (attributes.fetch('bitrate').to_f / 1000000)
  end

end