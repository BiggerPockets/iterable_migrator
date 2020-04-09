# frozen_string_literal: true

require 'active_record'

ActiveRecord::Base.establish_connection(
  host: ENV['REDSHIFT_HOST'],
  port: ENV['REDSHIFT_PORT'],
  user: ENV['REDSHIFT_USER'],
  password: ENV['REDSHIFT_PASSWORD'],
  database: ENV['REDSHIFT_DATABASE'],
  adapter: 'redshift',
  schema_search_path: 'master1'
)
