# frozen_string_literal: true

require "active_record"

class RedshiftBase < ActiveRecord::Base
  establish_connection(
    host: ENV["REDSHIFT_HOST"],
    port: ENV["REDSHIFT_PORT"],
    user: ENV["REDSHIFT_USER"],
    password: ENV["REDSHIFT_PASSWORD"],
    database: ENV["REDSHIFT_DATABASE"],
    adapter: "redshift",
    schema_search_path: "master1"
  )

  self.abstract_class = true

  def readonly?
    true
  end

  def self.iterable_client
    @iterable_client ||= HTTP.headers("Api-Key" => ENV["ITERABLE_API_TOKEN"])
  end

  def self.migrate
    puts "Migrating #{all.count} #{name} records"

    all.find_in_batches(batch_size: 5000).with_index do |rows, i|
      puts "Processing #{name} batch #{i}"

      events = rows.map(&:to_iterable_event)

      body = { "events" => events }

      response = iterable_client.post("https://api.iterable.com/api/events/trackBulk", body: Oj.dump(body))

      parsed_response = Oj.load(response)

      puts "Successes: #{parsed_response["successCount"]} | Failures: #{parsed_response["failCount"]}"
    rescue Net::ReadTimeout
      puts "Timeout. Retrying."
      retry
    end
  end

  def to_iterable_event
    {
      "eventName" => event,
      "userId" => user_id,
      "id" => id,
      "createdAt" => received_at.to_i,
      "dataFields" => data_fields,
    }
  end

  def data_fields
    raise NotImplementedError
  end

  private

  def cast(attribute, field_type)
    case field_type
    when :string
      attributes[attribute]&.to_s
    when :integer
      attributes[attribute]&.to_i
    when :float
      attributes[attribute]&.to_f
    when :array
      Oj.load(attributes[attribute]) rescue []
    when :timestamp
      time = attributes[attribute]
      if time.blank?
        nil
      elsif time.is_a?(String)
        Time.parse(time).iso8601(3)
      else
        time.iso8601(3)
      end
    when :boolean
      attributes[attribute].to_s.downcase == "true"
    end
  end
end
