# frozen_string_literal: true

Bundler.require(:default)
Dotenv.load

require_relative "models/redshift_base"
require_relative "models/registered_for_webinar"

Iterable.configure do |config|
  config.token = ENV["ITERABLE_API_TOKEN"]
end
