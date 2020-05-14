# frozen_string_literal: true

require "mandrill"

class MandrillTemplate
  def self.migrate
    new.migrate
  end

  ITERABLE_TRANSACTIONAL_MESSAGE_TYPE_ID = 32372

  def initialize
    @conditionals = []
    @changed_subjects = []
  end

  def migrate
    failures = []

    templates.each do |template|
      slug = template["slug"].strip.underscore

      puts slug.to_s

      subject = if template["subject"].to_s.include? "{"
        @changed_subjects << [slug, template["subject"]]

        "{{ subject }}"
      else
        template["subject"]
      end

      response = iterable_endpoint.upsert(
        slug,
        metadata: {
          name: "Transactional: #{slug}",
        },
        name: "Transactional: #{slug}",
        clientTemplateId: slug,
        subject: subject,
        #fromName: template["from_name"],
        #fromEmail: template["from_email"],
        html: transform_to_handlebars(slug, template["code"]),
        plainText: transform_to_handlebars(slug, template["text"]),
        messageTypeId: ITERABLE_TRANSACTIONAL_MESSAGE_TYPE_ID
      )

      unless response.success?
        puts "WARNING: #{slug} import failed!"
        failures << slug
      end
    end

    puts "* Failures: \n#{failures.uniq.join("\n")}"
    puts "* Subjects changed: \n#{@changed_subjects.join("\n")}"
    puts "* Templates with conditionals: \n#{@conditionals.uniq.join("\n")}"
  end

  private

  def templates
    mandrill_client.templates.list
  end

  def mandrill_client
    @mandrill_client ||= Mandrill::API.new(ENV["MANDRILL_API_KEY"])
  end

  def iterable_endpoint
    Iterable::EmailTemplates.new
  end

  def transform_to_handlebars(slug, code)
    return if code.blank?

    code.
      gsub("date \"Y\"", "now format=\"yyyy\""). # clean handlebars
      gsub(/.*(\*\|)(.*)(\|\*).*/) do
        og = "#{$1}#{$2}#{$3}"
        $2.to_s.strip.downcase.underscore.
          yield_self do |s|
            s == "date:y" ? "now format=\"yyyy\"" : s
          end.
          yield_self do |s|
            s.gsub(/if:(.*)=(.*)/) do
              "if (eq \"#{$1}\" \"#{$2}\")"
            end
          end.
          yield_self { |s| @conditionals << slug; s.gsub("end:if", "!endif") }.
          yield_self { |s| s.gsub("else:", "!else") }.
          yield_self do |s|
            s.gsub(/if:(.*)/) do
              "!if \"#{$1}\""
            end
          end.
          yield_self do |s|
            if s.include? "html:"
              "{{{ #{s.sub('html:', '')} }}}"
            elsif s.include? "!"
              "{{#{s}}}"
            else
              "{{ #{s} }}"
            end
          end.
          tap do |replacement|
            puts "replacing #{og} with #{replacement}"
          end
      end
  end
end
