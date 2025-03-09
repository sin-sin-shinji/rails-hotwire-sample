require 'test_helper'
require 'capybara/playwright'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :playwright, using: :chromium, screen_size: [ 1400, 900 ]
end
