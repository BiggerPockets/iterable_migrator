
# frozen_string_literal: true

class PurchasedBook < RedshiftBase
  self.table_name = "purchased_book"

  # 100728

  def event
    "Purchased Book"
  end

  def data_fields
    {
      "book_type" => cast("book_type", :string),
      "revenue" => cast("revenue", :float),
      "discount_code" => cast("discount_code", :string)
    }
  end
end
