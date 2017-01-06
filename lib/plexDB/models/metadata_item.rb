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