# frozen_string_literal: true

Bundler.require(:default)
Dotenv.load

require "csv"
require_relative "models/redshift_base"
require_relative "blueshift_user"

Dir[File.join(__dir__, "models", "*.rb")].each { |file| require file }

Iterable.configure do |config|
  config.token = ENV["ITERABLE_API_TOKEN"]
end
