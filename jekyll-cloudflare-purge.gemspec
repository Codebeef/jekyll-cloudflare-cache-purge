# frozen_string_literal: true

require_relative "lib/jekyll-cloudflare-cache-purge/version"

Gem::Specification.new do |spec|
  spec.name             = "jekyll-cloudflare-cache-purge"
  spec.version          = Jekyll::CloudflareCachePurge::VERSION
  spec.authors          = ["Matt Hall"]
  spec.email            = ["matt@codebeef.com"]
  spec.summary          = "A Jekyll plugin to purge the cloudflare cache on build"
  spec.homepage         = "https://github.com/codebeef/jekyll-cloudflare-cache-purge"
  spec.license          = "MIT"

  spec.files            = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README.md", "History.markdown", "LICENSE.txt"]
  spec.test_files       = spec.files.grep(%r!^spec/!)
  spec.require_paths    = ["lib"]

  spec.required_ruby_version = ">= 2.5.0"

  spec.add_dependency "jekyll", ">= 3.7", "< 5.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop-jekyll", "~> 0.12.0"
  spec.add_development_dependency "typhoeus", ">= 0.7", "< 2.0"
  spec.add_development_dependency "webmock", "~> 3.23.0"
end
