# frozen_string_literal: true

require "bundler/inline"
require "csv"

gemfile do
  source "https://rubygems.org"
  gem "byebug"
  gem "activesupport"
end

require "active_support/core_ext"

OUTPUT_FILE_NAME = "seedlist.csv"
INPUT_FILE_NAME = "cohort.csv"

File.delete(OUTPUT_FILE_NAME) if File.exist?(OUTPUT_FILE_NAME)

CSV.open(OUTPUT_FILE_NAME, "wb") do |csv|
  CSV.foreach(INPUT_FILE_NAME, headers: true).with_index do |row, _i|
    email = row["gp:email"]
    next if email.squish.blank?

    csv << [email.split("@").last]
  end
end
