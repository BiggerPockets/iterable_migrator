# frozen_string_literal: true

class RegisteredForWebinar < RedshiftBase
  self.table_name = "registered_for_webinar"

  # 930477

  def event
    "Registered for Webinar"
  end

  def data_fields
    {
      "campaign" => campaign,
      "medium" => medium,
      "source" => source,
      "webinar_id" => webinar_id,
    }
  end
end
