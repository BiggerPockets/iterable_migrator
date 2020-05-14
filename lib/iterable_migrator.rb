# frozen_string_literal: true

Bundler.require(:default)
Dotenv.load

require "csv"
require_relative "models/redshift_base"
require_relative "models/first_time_base"
require_relative "blueshift_user"
require_relative "mailchimp_user"
require_relative "mandrill_template"
# require "httplog" # Additional HTTP debugging

Dir[File.join(__dir__, "models", "*.rb")].each { |file| require file }

Iterable.configure do |config|
  config.token = ENV["ITERABLE_API_TOKEN"]
end
