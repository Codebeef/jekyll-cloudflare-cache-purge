# jekyll-cloudflare-cache-purge

[![Gem Version](https://badge.fury.io/rb/jekyll-cloudflare-cache-purge.svg)](https://badge.fury.io/rb/jekyll-cloudflare-cache-purge)
[![RSpec](https://github.com/Codebeef/jekyll-cloudflare-cache-purge/actions/workflows/rspec.yml/badge.svg)](https://github.com/Codebeef/jekyll-cloudflare-cache-purge/actions/workflows/rspec.yml)

Sends a request to cloudflare once jekyll has finished building your sire to
clear the cache there.

## Usage

Add the following to your site's `Gemfile`

```
gem 'jekyll-cloudflare-cache-purge'
```

Define two env vars on the system that builds and hosts your blog:

```
CLOUDFLARE_ZONE="<Get this value from your CF dashboard>"
CLOUDFLARE_API_TOKEN="<Create an api key just for purging the cache in CF>"
```

Once your blog has built, you should see a line appear in the build output that
reads `Cloudflare Cache: Purged`
