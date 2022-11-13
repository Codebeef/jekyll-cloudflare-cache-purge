# frozen_string_literal: true

class CloudflareCachePurge
  def self.run
    new.tap(&:run)
  end

  def run
    if env_vars_missing?
      return Jekyll.logger.warn("Cloudflare Cache:",
                                "Skipping - please set CLOUDFLARE_API_TOKEN " \
                                "and CLOUDFLARE_ZONE to enable")
    end

    if response.is_a?(Net::HTTPSuccess)
      Jekyll.logger.info "Cloudflare Cache:", "Purged"
    else
      Jekyll.logger.warn "Cloudflare Cache:", "FAILED: #{response.body}"
    end
  end

  def response
    @response ||= http.request(request)
  end

  def request
    @request ||= Net::HTTP::Post.new(uri.request_uri).tap do |req|
      req["Authorization"] = "Bearer #{ENV.fetch("CLOUDFLARE_API_TOKEN")}"
      req["Content-Type"] = "application/json"
      req.body = '{"purge_everything":true}'
    end
  end

  def http
    @http ||= Net::HTTP.new(uri.host, uri.port).tap do |h|
      h.use_ssl = true
      h.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end
  end

  def uri
    @uri ||= URI("https://api.cloudflare.com/client/v4/zones/#{ENV.fetch("CLOUDFLARE_ZONE")}/purge_cache")
  end

  def env_vars_missing?
    %w(CLOUDFLARE_API_TOKEN CLOUDFLARE_ZONE).each do |key|
      return true unless ENV.key?(key)
    end

    false
  end
end

Jekyll::Hooks.register :site, :post_write do |_page|
  CloudflareCachePurge.run
end
