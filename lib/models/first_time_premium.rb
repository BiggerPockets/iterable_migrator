
# frozen_string_literal: true

class FirstTimePremium < FirstTimeBase
  self.table_name = "first_time_premium"

  def event
    "First Time Premium"
  end
end
