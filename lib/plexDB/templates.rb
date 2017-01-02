module PlexDB

  module Templates
    extend self

    def movie_template
      @movie_template ||= Liquid::Template.parse(SETTINGS['movie_template'])
    end

    def tv_template
      @tv_template ||= Liquid::Template.parse(SETTINGS['tv_template'])
    end
  end

end