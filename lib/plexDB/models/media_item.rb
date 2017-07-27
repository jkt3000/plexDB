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

  # ["ac3", "aac", "mp3", "vorbis", "dca", "eac3", "truehd", "wmav2", ""]
  def audio_codec
    p self[:audio_codec], self[:audio_channels]
    @audio_codec ||= begin

      codec = case self[:audio_codec]
      when "ac3", "aac", "mp3", "dca"
        self[:audio_codec].upcase
      when "eac3"
        "EC3"
      when "truehd"
        "TrueHD"        
      else
        nil
      end
      ch = self[:audio_channels].present? ? "#{self[:audio_channels]}ch" : nil
      [codec,ch].compact.join(" ")
    end 
  end

  # ["h264", "mpeg4", "hevc", "vc1", "msmpeg4v3", ""]
  def video_codec
    @video_codec ||= begin
      case self[:video_codec]
      when "h264"
        'H264'
      when "mpeg4"
        'MP4'
      when 'hevc'
        "HEVC"
      else
        nil
      end
    end 
  end


end