# frozen_string_literal: true

class RegisteredForWebinar < RedshiftBase
  self.table_name = "registered_for_webinar"

  # validates :user_id, numericality: { only_integer: true }

  def self.migrate
    iterable_client = HTTP.headers("Api-Key" => ENV["ITERABLE_API_TOKEN"])

    all.limit(1000).find_in_batches(batch_size: 100).each do |registered_for_webinars|
      events = registered_for_webinars.map(&:to_iterable_event)

      body = { "events" => events }

      response = iterable_client.post("https://api.iterable.com/api/events/trackBulk", body: Oj.dump(body))
      puts response
      puts "Successes: #{Oj.load(response)["successCount"]} | Failures: #{Oj.load(response)["failCount"]}"
    end
  end

  def to_iterable_event
    # return unless valid?

    {
      "eventName" => event,
      "userId" => user_id,
      "id" => id,
      "createdAt" => received_at.to_i,
      "dataFields" => {
        "campaign" => campaign,
        "medium" => medium,
        "source" => source,
        "webinar_id" => webinar_id
      }
    }
  end
end
