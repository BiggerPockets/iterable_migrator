
# frozen_string_literal: true

class FirstTimeBase < RedshiftBase
  self.abstract_class = true

  def data_fields
    {
      "coupon" => cast("coupon", :string),
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
      "marketing" => cast("marketing", :boolean),
      "plan_term" => cast("plan_term", :string),
      "plan_type" => cast("plan_type", :string),
      "used_coupon" => cast("used_coupon", :boolean),
    }
  end
end
