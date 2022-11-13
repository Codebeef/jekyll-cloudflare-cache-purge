# frozen_string_literal: true

require "spec_helper"

describe CloudflareCachePurge do
  let(:configs) do
    Jekyll.configuration(
      "skip_config_files" => false,
      "source"            => fixtures_dir,
      "destination"       => fixtures_dir("_site")
    )
  end

  let(:site) { Jekyll::Site.new(configs) }
  let(:logger) do
    instance_double(Jekyll::LogAdapter, :adjust_verbosity => true, :warn => true, :info => true,
   :debug => true)
  end

  before do
    allow(Jekyll).to receive(:logger).and_return(logger)
  end

  context "without configured env vars" do
    before do
      ENV.delete("CLOUDFLARE_ZONE")
      ENV.delete("CLOUDFLARE_API_TOKEN")

      site.process
    end

    it "does not post to cloudflare" do
      expect(WebMock).not_to have_requested(:post, "https://api.cloudflare.com/client/v4/zones/TEST_ZONE/purge_cache")
    end

    it "logs that the ping will be skipped" do
      expect(logger).to have_received(:warn).with("Cloudflare Cache:",
                                                  "Skipping - please set CLOUDFLARE_API_TOKEN " \
                                                  "and CLOUDFLARE_ZONE to enable")
    end
  end

  context "with the env vars set" do
    before do
      ENV["CLOUDFLARE_ZONE"] = "TEST_ZONE"
      ENV["CLOUDFLARE_API_TOKEN"] = "TEST_AUTH_TOKEN"
    end

    context "with a failure response from cloudflare" do
      before do
        stub_request(:post, "https://api.cloudflare.com/client/v4/zones/TEST_ZONE/purge_cache")
          .with(:headers => {
            "Content-Type"  => "application/json",
            "Authorization" => "Bearer TEST_AUTH_TOKEN",
          })
          .to_return(:status => 403, :body => "Forbidden")

        site.process
      end

      it "logs the error notification" do
        expect(logger).to have_received(:warn).with("Cloudflare Cache:", "FAILED: Forbidden")
      end
    end

    context "with a successful response from cloudflare" do
      before do
        stub_request(:post, "https://api.cloudflare.com/client/v4/zones/TEST_ZONE/purge_cache")
          .with(:headers => {
            "Content-Type"  => "application/json",
            "Authorization" => "Bearer TEST_AUTH_TOKEN",
          })
          .to_return(:status => 200, :body => "")

        site.process
      end

      it "logs the success message" do
        expect(logger).to have_received(:info).with("Cloudflare Cache:", "Purged")
      end
    end
  end
end
