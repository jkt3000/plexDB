require 'test_helper'

class PlexDB::RenamerTest < ActiveSupport::TestCase

  def setup
    @path = '/test/path'
    @renamer = PlexDB::Renamer.new(@path, preview: true, force: false)
  end

  test "#valid_file returns nil if not a video file" do
    assert_nil @renamer.valid_file?("invalid_file.txt")
  end

  test "#valid_file returns nil if file size < min size" do
    File.expects(:size).returns(199.megabytes)
    assert_nil @renamer.valid_file?("invalid_file.mp4")
  end

  test "#valid_file returns nil if file can not be found in plexDB" do
  end



end
