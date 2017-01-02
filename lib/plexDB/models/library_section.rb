# library_sections
# id:
# library_id:
# name:
# name_sort:
# section_type:
# language:
# agent:
# scanner:
# user_thumb_url:
# user_art_url:
# user_theme_music_url:
# public:
# created_at:
# updated_at:
# scanned_at:
# display_secondary_level:
# user_fields:
# query_type:
# uuid:

require 'safe_attributes/base'

class LibrarySection < ActiveRecord::Base 
  include SafeAttributes::Base

  bad_attribute_names :hash, :size, :index

  def type
    case section_type
    when 1
      "Movie"
    when 2
      "TV"
    end
  end
end