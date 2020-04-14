
# frozen_string_literal: true

class MortgageAffiliateLinkClicked < RedshiftBase
  self.table_name = "mortgage_affiliate_link_clicked"

  def data_fields
    {
      "affiliateId" => cast("affiliate_id", :integer),
      "affiliateName" => cast("affiliate_name", :string),
      "url" => cast("url", :string),
      "date" => cast("date", :timestamp),
      "designType" => cast("design_type", :string),
    }
  end
end
