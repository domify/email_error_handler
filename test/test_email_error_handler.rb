# frozen_string_literal: true

require "test_helper"

class TestEmailErrorHandler < Minitest::Test
  describe EmailErrorHandler do
    before do
      @email = Email.new
    end

    it 'should have a version number' do
      refute_nil ::EmailErrorHandler::VERSION
    end

    it 'should deliver test email' do
      assert 'OK', @email.deliver
    end

    it 'should rescue smtp errors' do
      @email.stub :deliver_test_email, -> { raise Net::SMTPAuthenticationError.new("Fake Error") } do
        @email.save
      end
      assert_includes @email.delivery_errors_info, 'E-mail server authentication error'
    end

    it 'should rescue smtp fatal errors' do
      @email.stub :deliver_test_email, -> { raise Net::SMTPFatalError.new("Fake Error") } do
        @email.save
      end
      assert_includes @email.delivery_errors_info, 'E-mail server fatal error'
    end

    it 'should rescue smtp unknown errors' do
      @email.stub :deliver_test_email, -> { raise Net::SMTPUnknownError.new("Fake Error") } do
        @email.save
      end
      assert_includes @email.delivery_errors_info, 'E-mail server unknown error'
    end

    it 'should rescue smtp server busy errors' do
      @email.stub :deliver_test_email, -> { raise Net::SMTPServerBusy.new("Fake Error") } do
        @email.save
      end
      assert_includes @email.delivery_errors_info, 'E-mail server busy'
    end

    it 'should rescue open timeout errors' do
      @email.stub :deliver_test_email, -> { raise Net::OpenTimeout.new("Fake Error") } do
        @email.save
      end
      assert_includes @email.delivery_errors_info, 'Connection timeout'
    end

    it 'should rescue read timeout errors' do
      @email.stub :deliver_test_email, -> { raise Net::ReadTimeout.new("Fake Error") } do
        @email.save
      end
      assert_includes @email.delivery_errors_info, 'Server timeout'
    end
  end
end
