
# frozen_string_literal: true

class RenewalScore < RedshiftBase
  self.table_name = "renewal_score"

  # 27590

  def data_fields
    {
      "score" => cast("score", :float)
    }
  end
end
