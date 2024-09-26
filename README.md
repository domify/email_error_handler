# EmailErrorHandler

**EmailErrorHandler** is a Ruby gem designed to provide error handling
for email delivery in Rails applications. 
It helps manage common SMTP-related errors like authentication failures, timeouts, and recipient rejections. 
The gem decouples email delivery from error handling, allowing you to use your own mailers and models with minimal overhead.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add email_error_handler

## Usage

To use EmailErrorHandler, wrap your email delivery logic inside 
the wrap block. The gem will automatically handle and log any 
SMTP-related errors.

````Ruby
class YourEmailModel < ApplicationRecord
  include EmailDeliveryError

  def deliver_email(email)
    store_email_delivery_errors do
      # Your custom email delivery logic here
      UserMailer.main(self).deliver_now
    end
  end
  # Ensure necessary columns exist in your model: delivery_errors
end
````

In this example, MyMailer.notification(email).deliver_now is 
the user's email delivery logic. 
EmailErrorHandler wraps it inside the wrap block, 
ensuring that any SMTP-related errors are caught, stored and handled gracefully.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/domify/email_error_handler.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
