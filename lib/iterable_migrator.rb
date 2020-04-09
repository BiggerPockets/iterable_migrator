# frozen_string_literal: true

Bundler.require(:default)
Dotenv.load

require "csv"
require_relative "models/redshift_base"
require_relative "models/registered_for_webinar"
require_relative "blueshift_user"

Iterable.configure do |config|
  config.token = ENV["ITERABLE_API_TOKEN"]
end
