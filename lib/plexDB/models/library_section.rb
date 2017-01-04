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