# frozen_string_literal: true

Bundler.require(:default)
Dotenv.load

require 'redshift'
require 'models/redshift_base'
require 'models/registered_for_webinar'
