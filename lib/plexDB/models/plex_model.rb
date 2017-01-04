class PlexModel
  attr_reader :title, :year, :type, :filename, :ext, :path, :season, :episode,
              :width, :height,
              :media_part,
              :metadata,


  def initialize(params)
    params = ActiveSupport::HashWithIndifferentAccess.new(params)
    @title      = params.fetch(:title)
    @year       = params.fetch(:year, nil)
    @width      = params.fetch(:width, nil)
    @height     = params.fetch(:height, nil)
    @ext        = params.fetch(:ext, nil)
    @type       = params.fetch(:type, nil)
    @filename   = params.fetch(:filename, nil)
    @path       = params.fetch(:path, nil)

    @season     = params.fetch(:season, nil)
    @episode    = params.fetch(:episode, nil)

    @media_part = params.fetch(:media_part, nil)
    @metadata   = params.fetch(:metadata, nil)
  end

  # we can have lots of versions...
  def self.create_from_metadata(metadata)
  end

  def self.create_from_media_part(media_part)
    metadata = media_part.media_item.metadata_item
    params = {
      title: media_part.title,
      year:  media_part.year,
      width: media_part.width,
      height: media_part.height,
      ext:   media_part.ext,
      type:  media_part.type,
      filename: media_part.filename,
      path: media_part.path,
      media_part: media_part,
      metadata: metadata
    }
    if media_part.type.upcase == 'TV'
      params.merge!({season: metadata.season_number, episode: metadata.episode_number})
    end

    PlexModel.new(params)
  end

  # type    width     height
  # -------------------------
  # HQ      >= 3860   >= 2160
  # 1080p   >= 1920   >= 1080
  # 720p    >= 1280   >= 720
  # SD      the rest
  def resolution
    if width >= 3860 || height >= 2160
      "HQ"
    elsif width >= 1920 || height >= 1080
      "1080p"
    elsif width >= 1280 || height >= 720
      "720p"
    else
      "SD"
    end
  end

  def to_liquid
    {
      title: title.gsub(/\//, "_"),
      year: year,
      resolution: resolution,
      ext: ext,
      filename: filename,
      path: path,
      season: "%02d" % season,
      episode: "%02d" % episode
    }.stringify_keys
  end

end