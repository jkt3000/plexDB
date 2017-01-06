# :id
# :library_section_id
# :parent_id
# :metadata_type
# :guid
# :media_item_count
# :title
# :title_sort
# :original_title
# :studio
# :rating
# :rating_count
# :tagline
# :summary
# :trivia
# :quotes
# :content_rating
# :content_rating_age
# :index
# :absolute_index
# :duration
# :user_thumb_url
# :user_art_url
# :user_banner_url
# :user_music_url
# :user_fields
# :tags_genre
# :tags_collection
# :tags_director
# :tags_writer
# :tags_star
# :originally_available_at
# :available_at
# :expires_at
# :refreshed_at
# :year
# :added_at
# :created_at
# :updated_at
# :deleted_at
# :tags_country
# :extra_data

require 'safe_attributes/base'

class MetadataItem < ActiveRecord::Base
  include SafeAttributes::Base

  # metadata_type
  MOVIE   = 1
  SHOW    = 2
  SEASON  = 3
  EPISODE = 4

  bad_attribute_names :hash, :size, :index

  belongs_to :library_section
  has_many :media_items

  def type
    library_section.type
  end

  def title
    case metadata_type 
    when MOVIE, SHOW
      self[:title]
    else
      parent.title
    end
  end

  def season_number
    metadata_type == SEASON ? index : season_obj.index
  end

  def episode_number
    metadata_type == EPISODE ? index : nil
  end

  def episode
    metadata_type == EPISODE ? self : nil
  end

  def season_obj
    @season_obj ||= MetadataItem.where(id: parent_id, metadata_type: SEASON).first
  end

  def show_obj
    @show_obj ||= MetadataItem.where(id: parent_id, metadata_type: SHOW).first
  end

  private

  def parent
    @parent ||= MetadataItem.where(id: parent_id).first
  end
end