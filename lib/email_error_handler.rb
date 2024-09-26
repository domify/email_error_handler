# frozen_string_literal: true

require 'rails'
require 'net/smtp'
require "i18n"
require_relative "email_error_handler/version"
require_relative "email_error_handler/engine" if defined?(Rails::Engine)

module EmailErrorHandler
  class << self
    def included(base)
      base.include(InstanceMethods)
    end

    module InstanceMethods
      def store_email_delivery_errors
        begin
          yield
        rescue Net::SMTPAuthenticationError => e
          delivery_error!(e, :smtp_authentication_error)
        rescue Net::SMTPFatalError => e
          delivery_error!(e, :smtp_fatal_error)
        rescue Net::SMTPUnknownError => e
          delivery_error!(e, :smtp_unknown_error)
        rescue Net::SMTPServerBusy => e
          delivery_error!(e, :smtp_server_busy)
        rescue Net::OpenTimeout => e
          delivery_error!(e, :connection_timeout)
        rescue Net::ReadTimeout => e
          delivery_error!(e, :server_timeout)
        end
      end

      def delivery_error!(exception, type)
        Rails.logger.error "Email Delivery Error: #{type}, #{exception.class} => #{exception.message}"

        # rubocop:disable Rails/SkipsModelValidations
        update_columns(
          delivery_errors: [[ Time.current.utc.iso8601, type, exception.message ]] + delivery_errors
        )
        # rubocop:enable Rails/SkipsModelValidations
      end

      def delivery_info
        sent_at.present? ? I18n.l(sent_at) : delivery_errors_info
      end

      def delivery_errors_info
        return "" if delivery_errors.blank?

        delivery_errors_translated.join(', ')
      end

      def delivery_errors_translated
        return [] if delivery_errors.blank?

        delivery_errors.map do |(timestamp, error_type, message)|
          # Define the base string with the translated error type and timestamp
          base_string = I18n.t("email_error_handler.#{error_type}") + ": " + "[#{I18n.l(Time.zone.parse(timestamp))}]"

          # Calculate how many characters are left for the message
          max_message_length = 128 - base_string.length - 3 # Account for ": " and possible truncation indicator "..."

          # Shorten the message if necessary, adding "..." to indicate truncation
          short_message = message.length > max_message_length ? message[0...max_message_length] + "..." : message

          # Combine the base string and shortened message
          "#{I18n.t("email_error_handler.#{error_type}")}: #{short_message} [#{I18n.l(Time.zone.parse(timestamp))}]"
        end
      end
    end
  end
end
