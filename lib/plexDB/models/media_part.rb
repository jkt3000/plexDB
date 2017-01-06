# media_parts
# :id
# :media_item_id
# :directory_id
# :file           - file name/location of file
# :index
# :size
# :duration
# :created_at
# :updated_at
# :deleted_at

require 'safe_attributes/base'

class MediaPart < ActiveRecord::Base
  include SafeAttributes::Base

  bad_attribute_names :hash, :size, :index

  belongs_to :media_item
  belongs_to :directory

  delegate :title, :year, :width, :height, :dimension, :type, to: :media_item

  def path
    File.dirname(file)
  end

  def filename
    File.basename(file, "*.*")
  end

  def ext
    File.extname(file).gsub(/\./,'')
  end
end