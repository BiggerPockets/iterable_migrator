# frozen_string_literal: true

require 'bundler/inline'
require 'csv'

gemfile do
  source 'https://rubygems.org'
  gem 'byebug'
end

OUTPUT_FILE_NAME = 'output.csv'
MAP = {
}.freeze

def headers(row)
  row.headers.map do |k|
    next if k.include? '[Optimizely Experiment]'
    next if k.include? 'run_business_better:'
    next if k.include? 'network:'
    next if k.include? 'learn:'
    next if k.include? 'kind_of_deals_have_done:'
    next if k.include? ':involvement'
    next if k.include? ':involved'
    next if k.include? ':investment'
    next if k.include? ':investing_pursuits'
    next if k.include? ':investing-in-real-estates'
    next if k.include? ':interested-in'
    next if k.include? ':help_run_business_better'
    next if k.include? ':goals:'
    next if k.include? ':deals:'
    next if k.include? 'kind_of_deals:'
    next if k.include? 'investing_goals:'
    next if k.include? ':currently-investing'
    next if k.include? ':achieve_goals:'
    next if k.include? 'gp:Blog '
    next if k.include? 'gp:Dashboard '
    next if k.include? 'gp:Experiment: '
    next if k.include? 'gp:Dashboard '
    next if k.include? ':test_'
    next if k.include? ':kind_of_deals_in_plans:'
    next if k.include? ':kind_of_vendor:'
    next if k.include? '|'
    next if k.include? '('
    next if k.include? 'eddtest'
    next if k.include? 'next_purchase:'
    next if k.include? 'eddtest'
    next if k.include? 'eddtest'
    next if k.include? 'eddtest'
    next if k.include? 'eddtest'

    k.sub('gp:', '')
  end.compact
end

def values(row)
  row.values('gp:email')
end

File.delete(OUTPUT_FILE_NAME) if File.exist?(OUTPUT_FILE_NAME)

CSV.open(OUTPUT_FILE_NAME, 'wb') do |csv|
  counter = 0
  CSV.foreach('cohort.csv', headers: true) do |row|
    puts headers(row)
    puts headers(row).size
    # csv << headers(row) if counter.zero?

    break

    csv << []

    counter += 1
  end
end
