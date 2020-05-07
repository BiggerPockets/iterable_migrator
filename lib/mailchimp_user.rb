# frozen_string_literal: true

class MailchimpUser
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email, :string
  attribute :first_name, :string
  attribute :last_name, :string

  def self.migrate
    users_endpoint = Iterable::Users.new

    CSV.new(File.open(File.join("data", "mailchimp", "difference.csv")), headers: true).lazy.each_slice(1000).with_index do |rows, i|
      puts "Processing batch #{i}"

      # Bulk update
      users = rows.map do |row|
        new(email: row["Email Address"], first_name: row["First Name"], last_name: row["Last Name"]).
          to_iterable_properties.
          merge("preferUserId" => false, "mergeNestedObjects" => true)
      end

      response = users_endpoint.bulk_update(users)

      puts "Successes: #{response.body["successCount"]} | Failures: #{response.body["failCount"]}"
    rescue Net::ReadTimeout
      retry
    end
  end

  def to_iterable_properties
    {
      "email" => email,
      "dataFields" => {
        "subscribed" => true,
        "first_name" => first_name,
        "last_name" => last_name,
        "imported_from" => "Mailchimp"
      }
    }
  end
end
