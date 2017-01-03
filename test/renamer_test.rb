require 'test_helper'

class PlexDB::RenamerTest < ActiveSupport::TestCase

  def setup
    @path = '/test/path'
    @renamer = PlexDB::Renamer.new(curr_path: @path, preview_only: true, require_confirmation: false)
  end




  # valid_new_filename

  test "#valid_new_filename increments filename if file already exists" do
    @file = load_file('movie.mp4')
    assert_equal "movie_2.mp4", File.basename(@renamer.valid_new_filename(@file))
  end

  test "#valid_new_filename returns filename if file doesn't exit" do
    @file = load_file('sample_movie.mp4')
    assert_equal "sample_movie.mp4", File.basename(@renamer.valid_new_filename(@file))
  end


end
