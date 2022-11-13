# frozen_string_literal: true

require "jekyll"
require "webmock/rspec"
require File.expand_path("../lib/jekyll-cloudflare-cache-purge/", __dir__)

FIXTURES_DIR = File.expand_path("fixtures", __dir__)

Jekyll.logger.log_level = :error

WebMock.disable_net_connect!

RSpec.configure do |config|
  def fixtures_dir(*paths)
    File.join(FIXTURES_DIR, *paths)
  end

  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = "random"
end
