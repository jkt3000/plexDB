$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'plexDB'

require 'minitest/autorun'
require 'active_support/test_case'
require 'mocha/mini_test'


class ActiveSupport::TestCase

  FILE_PATH = File.expand_path('./../files', __FILE__)

  def load_file(file)
    File.join(FILE_PATH, file)
  end

end