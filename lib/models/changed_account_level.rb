
# frozen_string_literal: true

class ChangedAccountLevel < RedshiftBase
  self.table_name = "changed_account_level"

  def data_fields
    {
      "companySlug" => cast("company_slug", :string),
      "coupon" => cast("coupon", :string),
      "date" => cast("date", :timestamp),
      "newPlanType" => cast("new_plan_type", :string),
      "newTerm" => cast("new_term", :string),
      "newUpgradeService" => cast("new_upgrade_service", :boolean),
      "path" => cast("path", :string),
      "previousPlanType" => cast("previous_plan_type", :string),
      "previousTerm" => cast("previous_term", :string),
      "referrer" => cast("referrer", :string),
      "source" => cast("source", :string),
      "userId" => cast("user_id", :string),
    }
  end
end
