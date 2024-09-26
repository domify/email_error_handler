# frozen_string_literal: true

class Email < ActiveRecord::Base
  include EmailErrorHandler

  after_commit :deliver
  def deliver
    store_email_delivery_errors do
      deliver_test_email
    end
  end

  def deliver_test_email
    # UserMailer.main(self).deliver_now
    "OK"
  end
end
