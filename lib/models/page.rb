
# frozen_string_literal: true

class Page < RedshiftBase
  self.table_name = "pages"

  def data_fields
    {
      "city" => cast("city", :string),
      "first_campaign" => cast("first_campaign", :string),
      "first_content" => cast("first_content", :string),
      "first_medium" => cast("first_medium", :string),
      "first_source" => cast("first_source", :string),
      "first_term" => cast("first_term", :string),
      "latest_campaign" => cast("latest_campaign", :string),
      "latest_content" => cast("latest_content", :string),
      "latest_medium" => cast("latest_medium", :string),
      "latest_source" => cast("latest_source", :string),
      "latest_term" => cast("latest_term", :string),
      "path" => cast("path", :string),
      "platform" => cast("platform", :string),
      "referrer" => cast("referrer", :string),
      "search" => cast("search", :string),
      "state" => cast("state", :string),
      "title" => cast("title", :string),
      "url" => cast("url", :string),
      "visitorType" => cast("visitor_type", :string),
    }
  end
end
