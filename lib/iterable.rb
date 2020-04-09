# frozen_string_literal: true

Bundler.require(:default)
Dotenv.load

require_relative 'redshift'
require_relative 'models/redshift_base'
require_relative 'models/registered_for_webinar'
