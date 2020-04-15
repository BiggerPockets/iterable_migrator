# frozen_string_literal: true

class Page
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :user_id, :string
  attribute :received_at, :string

  attribute :city, :string
  attribute :first_campaign, :string
  attribute :first_content, :string
  attribute :first_medium, :string
  attribute :first_source, :string
  attribute :first_term, :string
  attribute :latest_campaign, :string
  attribute :latest_content, :string
  attribute :latest_medium, :string
  attribute :latest_source, :string
  attribute :latest_term, :string
  attribute :path, :string
  attribute :platform, :string
  attribute :referrer, :string
  attribute :search, :string
  attribute :state, :string
  attribute :title, :string
  attribute :url, :string
  attribute :visitor_type, :string

  def self.migrate
    puts "Opening connection..."
    rows = []
    connection = RedshiftBase.connection.raw_connection

    # Feeds the DB with the query it will run
    # But it does NOT execute it yet!
    connection.send_query('SELECT * FROM "pages" WHERE "pages"."received_at" > \'2019-04-02\'')

    # This line alone would solve our problems, as it sets DB’s mode
    # as single line, which instead of sending the results all at once,
    # it sends them line by line, as requested by the application.
    connection.set_single_row_mode

    # This will return the next result from DB, and if you use stream_each
    # right after it, it will stream the results one by one until there
    # are no more results to fetch.
    connection.get_result.stream_each do |row|
      rows << Page.new(row.slice(*attribute_types.keys))

      if rows.size >= 4999
        process_batch(rows)

        rows.clear
      end
    end
  end

  def self.process_batch(rows)
    puts "Processing #{name} batch #{rows.first.received_at}"

    events = rows.map(&:to_iterable_event)

    body = { "events" => events }

    response = iterable_client.post("https://api.iterable.com/api/events/trackBulk", body: Oj.dump(body))

    parsed_response = Oj.load(response)

    puts "Successes: #{parsed_response["successCount"]} | Failures: #{parsed_response["failCount"]}"
  end

  def self.iterable_client
    @iterable_client ||= HTTP.use(:auto_deflate).headers("Api-Key" => ENV["ITERABLE_API_TOKEN"])
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

  def event
    "Loaded a Page"
  end

  def data_fields
    {
      "city" => city,
      "first_campaign" => first_campaign,
      "first_content" => first_content,
      "first_medium" => first_medium,
      "first_source" => first_source,
      "first_term" => first_term,
      "latest_campaign" => latest_campaign,
      "latest_content" => latest_content,
      "latest_medium" => latest_medium,
      "latest_source" => latest_source,
      "latest_term" => latest_term,
      "path" => path,
      "platform" => platform,
      "referrer" => referrer,
      "search" => search,
      "state" => state,
      "title" => title,
      "url" => url,
      "visitorType" => visitor_type,
    }
  end
end
