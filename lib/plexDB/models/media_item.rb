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
  belongs_to :type
  
  # :file - absolute filename
  # :size - in bytes
  # :duration - in seconds

  delegate :title, :year, to: :metadata_item

  def options
    "#{screen_size}|#{audio_codec}-#{audio_channels}ch"
  end

  def screen_size
    case height 
    when (0..480)
      "480p"
    when (481..720)
      "720p"
    when (721..1080)
      "1080p"
    when (1081..2160)
      "HQ"
    else
    end
  end

  def bitrate
    "%.1f" % (attributes.fetch('bitrate').to_f / 1000000)
  end

end