# frozen_string_literal: true

class RedshiftBase < ActiveRecord::Base
  self.abstract_class = true

  def readonly?
    true
  end
end
