class PlexModel
  attr_reader :title, :year, :dimension, :ext, :type, :filename, :path, :season, :episode

  def initialize(params)
    params = ActiveSupport::HashWithIndifferentAccess.new(params)
    @title      = params.fetch(:title)
    @year       = params.fetch(:year, nil)
    @dimension  = params.fetch(:dimension, nil)
    @ext        = params.fetch(:ext, nil)
    @type       = params.fetch(:type, nil)
    @filename   = params.fetch(:filename, nil)
    @path       = params.fetch(:path, nil)

    @season  = params.fetch(:season, nil)
    @episode = params.fetch(:episode, nil)
  end

  # we can have lots of versions...
  def self.create_from_metadata(metadata)
  end

  def self.create_from_media_part(media_part)
    params = {
      title: media_part.title,
      year:  media_part.year,
      dimension: media_part.dimension,
      ext:   media_part.ext,
      type:  media_part.type,
      filename: media_part.filename,
      path: media_part.path,
    }
    if media_part.type == 'tv'
      params.merge!({season: media_part.season, episode: media_part.episode})
    end

    PlexModel.new(params)
  end


  # helpful attributes

  def resolution
    case dimension.split('x').last.to_i 
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

end