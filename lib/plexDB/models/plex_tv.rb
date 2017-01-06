class PlexTv < PlexModel

  attr_reader :season, :episode

  def initialize(params)
    super(params)
    @season  = params.fetch(:season)
    @episode = params.fetch(:episode)
  end


end