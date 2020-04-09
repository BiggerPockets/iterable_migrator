# frozen_string_literal: true

require "bundler/inline"
require "csv"

gemfile do
  source "https://rubygems.org"
  gem "byebug"
  gem "activesupport"
end

require "active_support/core_ext"

OUTPUT_FILE_NAME = "output.csv"
INPUT_FILE_NAME = "cohort.csv"

ALLOWED_COLS = [
  "Test: announcements_notifications_split",
  "Test: auto_expand_agent_filters",
  "Test: biggerpockets_ad_on_forum",
  "Test: blog_quick_signup",
  "Test: book_discount_dashboard_ad",
  "Test: confirm_cancel_90d_v2",
  "Test: confirm_cancel_testimonial",
  "Test: dashboard_checklist",
  "Test: dashboard_checklist_vendor",
  "Test: dashboard_recommended_articles",
  "Test: deal_diaries_dashboard",
  "Test: direct_onboarding_investors_to_dashboard",
  "Test: forum_nav_item_split_test",
  "Test: google_login_bottom",
  "Test: hidden_feed_items",
  "Test: homepage_performance",
  "Test: homepage_signup",
  "Test: improved_feed",
  "Test: investment_prompt_float_left",
  "Test: journal_offer_from_projournalupgrade_route",
  "Test: journal_promo_from_upgrade_form_dropdown",
  "Test: lender_intro_steps",
  "Test: min_password_length",
  "Test: mobile_app_links",
  "Test: modify_viewed_topic",
  "Test: nav_hide_topics_header",
  "Test: nav_signup_modal_v3",
  "Test: new_loans_page_first_design",
  "Test: new_onboarding_flow_v2",
  "Test: optimistic_sign_up_v2",
  "Test: password_security_check",
  "Test: path_to_purchase_link",
  "Test: prepopulate_goal_tracker",
  "Test: pro2019_show_premium",
  "Test: pro_checkout_redesign_v2_fixed",
  "Test: pro_confirm_cancel",
  "Test: pro_upgrade_for_journal",
  "Test: ptp_calculator_on_dashboard",
  "Test: recombee_split_test",
  "Test: related_topics_top",
  "Test: replaced_dashboard_with_itr",
  "Test: sign_up_to_reply_to_topics",
  "Test: signup_page_experience_test",
  "Test: skip_onboarding",
  "Test: tenant_screening_destination",
  "Test: test_forums_top_nav_guests",
  "Test: test_forums_top_nav_members",
  "Test: test_networking_oct2018",
  "Test: webinar_dashboard_modal_calendar",
  "Test: webinar_modal_for_recently_inactive",
  "alerts_count",
  "colleagues_count",
  "company",
  "created",
  "created_in_month",
  "date",
  "deactivated",
  "email",
  "first_name",
  "interests",
  "last_active_at",
  "last_name",
  "login",
  "marketing",
  "onboarding_page_responses",
  "paid_until",
  "plan_term",
  "plan_type",
  "profile_complete",
  "subscribed",
  "test_announcements_notifications_split",
  "test_dashboard_checklist",
  "test_dashboard_checklist_vendor",
  "test_improved_feed",
  "test_prepopulate_goal_tracker",
  "test_ptp_calculator_on_dashboard",
  "test_replaced_dashboard_with_itr",
  "test_skip_onboarding",
  "verified"
].freeze

File.delete(OUTPUT_FILE_NAME) if File.exist?(OUTPUT_FILE_NAME)

CSV.open(OUTPUT_FILE_NAME, "wb") do |csv|
  CSV.foreach(INPUT_FILE_NAME, headers: true).with_index do |row, i|
    data = row.to_h.map do |k, v|
      new_key = k.sub("gp:", "")
      next unless ALLOWED_COLS.include? new_key

      [new_key, v]
    end.compact.to_h

    next if data["email"].squish.blank?

    csv << data.keys if i.zero? # CSV headers
    csv << data.values

    puts i # track progress

    break if i == 999 # to output a subset
  end
end
