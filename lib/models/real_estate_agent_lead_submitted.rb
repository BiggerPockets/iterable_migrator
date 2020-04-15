
# frozen_string_literal: true

class RealEstateAgentLeadSubmitted < RedshiftBase
  self.table_name = "real_estate_agent_lead_submitted"

  # 3231

  def event
    "Real Estate Agent Lead Submitted"
  end

  def data_fields
    {
      "approvalStatus" => cast("approval_status", :string),
      "company_id" => cast("company_id", :integer),
      "company_name" => cast("company_name", :string),
      "deal" => cast("deal", :string),
      "logged_in" => cast("logged_in", :boolean),
      "maximumPrice" => cast("maximum_price", :integer),
      "minimumPrice" => cast("minimum_price", :integer),
      "premium" => cast("premium", :boolean),
      "propertyTypes" => cast("property_types", :array),
      "strategies" => cast("strategies", :array),
      "submission_type" => cast("submission_type", :string),
      "timeline" => cast("timeline", :string),
    }
  end
end
