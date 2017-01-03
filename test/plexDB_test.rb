require 'test_helper'

class PlexDBTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PlexDB::VERSION
  end

end
