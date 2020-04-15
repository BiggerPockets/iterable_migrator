# frozen_string_literal: true

class BlueshiftUser
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email, :string
  attribute :retailer_customer_id, :string
  attribute :last_visit_at, :string
  attribute :custom_attributes, :string

  INPUT_FILE_PATH = File.join("data", "blueshift.csv")

  def self.migrate
    CSV.new(File.open(INPUT_FILE_PATH), headers: true).lazy.each_slice(1000).with_index do |rows, i|
      puts "Processing batch #{i}"
      users_endpoint = Iterable::Users.new
      users = rows.map { |row| new(row.to_h.slice(*attribute_types.keys)).to_iterable_properties.merge("preferUserId" => true, "mergeNestedObjects" => true) }
      response = users_endpoint.bulk_update(users)
      puts response
    end
  end

  def to_iterable_properties
    {
      "email" => email,
      "userId" => retailer_customer_id,
      "dataFields" => {
        "alerts_count" => alerts_count,
        "colleagues_count" => colleagues_count,
        "company" => company,
        "created" => created,
        "created_in_month" => created_in_month,
        "date" => date,
        "deactivated" => deactivated,
        "first_name" => first_name,
        "interests" => interests,
        "last_active_at" => last_active_at,
        "last_visit_at" => last_visit_at,
        "last_name" => last_name,
        "login" => login,
        "marketing" => marketing,
        "onboarding_page_responses" => onboarding_page_responses,
        "paid_until" => paid_until,
        "plan_term" => plan_term,
        "plan_type" => plan_type,
        "profile_complete" => profile_complete,
        "subscribed" => subscribed,
        "test_announcements_notifications_split" => test_announcements_notifications_split,
        "test_dashboard_checklist" => test_dashboard_checklist,
        "test_dashboard_checklist_vendor" => test_dashboard_checklist_vendor,
        "test_improved_feed" => test_improved_feed,
        "test_prepopulate_goal_tracker" => test_prepopulate_goal_tracker,
        "test_ptp_calculator_on_dashboard" => test_ptp_calculator_on_dashboard,
        "test_replaced_dashboard_with_itr" => test_replaced_dashboard_with_itr,
        "test_skip_onboarding" => test_skip_onboarding,
        "verified" => verified,
      }
    }
  end

  private

  def alerts_count
    extra_attributes["alerts_count"]&.to_i 
  end

  def colleagues_count
    extra_attributes["colleagues_count"]&.to_i
  end

  def company
    extra_attributes["company"]
  end

  def created
    return unless extra_attributes["created"].present?

    DateTime.parse(extra_attributes["created"])
  end

  def created_in_month
    extra_attributes["created_in_month"]
  end

  def date
    return unless extra_attributes["date"].present?

    DateTime.parse(extra_attributes["date"])
  end

  def deactivated
    extra_attributes["deactivated"].to_s.downcase == "true"
  end

  def email
    super
  end

  def first_name
    extra_attributes["first_name"]
  end

  def interests
    Array(extra_attributes["interests"])
  end

  def last_active_at
    return unless extra_attributes["last_active_at"].present?

    DateTime.parse(extra_attributes["last_active_at"])
  end

  def last_name
    extra_attributes["last_name"]
  end

  def last_visit_at
    DateTime.parse(super) if super.present?
  end

  def login
    extra_attributes["login"]
  end

  def marketing
    extra_attributes["marketing"].to_s.downcase == "true"
  end

  def onboarding_page_responses
    Array(extra_attributes["onboarding_page_responses"])
  end

  def paid_until
    return unless extra_attributes["paid_until"].present?

    DateTime.parse(extra_attributes["paid_until"])
  end

  def plan_term
    extra_attributes["plan_term"]
  end

  def plan_type
    extra_attributes["plan_type"]
  end

  def profile_complete
    extra_attributes["profile_complete"]&.to_f
  end

  def subscribed
    extra_attributes["subscribed"].to_s.downcase == "true"
  end

  def test_announcements_notifications_split
    extra_attributes["test_announcements_notifications_split"]
  end

  def test_dashboard_checklist
    extra_attributes["test_dashboard_checklist"]
  end

  def test_dashboard_checklist_vendor
    extra_attributes["test_dashboard_checklist_vendor"]
  end

  def test_improved_feed
    extra_attributes["test_improved_feed"]
  end

  def test_prepopulate_goal_tracker
    extra_attributes["test_prepopulate_goal_tracker"]
  end

  def test_ptp_calculator_on_dashboard
    extra_attributes["test_ptp_calculator_on_dashboard"]
  end

  def test_replaced_dashboard_with_itr
    extra_attributes["test_replaced_dashboard_with_itr"]
  end

  def test_skip_onboarding
    extra_attributes["test_skip_onboarding"]
  end

  def verified
    extra_attributes["verified"].to_s.downcase == "true"
  end

  def extra_attributes
    @extra_attributes ||= Oj.load(custom_attributes.gsub("=>", ":"))
  end
end