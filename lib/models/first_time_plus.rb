
# frozen_string_literal: true

class FirstTimePlus < FirstTimeBase
  self.table_name = "first_time_plus"

  def event
    "First Time Plus"
  end
end
