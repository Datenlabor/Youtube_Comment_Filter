# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
class VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  YOUTUBE_CASSETTE = 'youtube_api'
  YOUTUBE_TITLE_CASSETTE = 'youtube_title_api'

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
    end
  end

  def self.configure_vcr_for_youtube
    VCR.configure do |c|
      c.filter_sensitive_data('<YOUTUBE_TOKEN>') { YT_TOKEN }
      c.filter_sensitive_data('<YOUTUBE_TOKEN_ESC>') { CGI.escape(YT_TOKEN) }
    end

    VCR.insert_cassette(
      YOUTUBE_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
