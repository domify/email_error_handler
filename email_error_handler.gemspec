# frozen_string_literal: true

require_relative "lib/email_error_handler/version"

Gem::Specification.new do |spec|
  spec.name = "email_error_handler"
  spec.version = EmailErrorHandler::VERSION
  spec.authors = ["Priit Tark"]
  spec.email = ["priit@domify.io"]

  spec.summary       = "A email error handler for Rails applications."
  spec.description   = "EmailErrorHandler provides error handling for email delivery in Rails applications, managing SMTP-related issues such as authentication failures, timeouts, and recipient rejections. This gem allows flexible handling, including logging errors and retrying failures, while integrating seamlessly into Rails apps."
  spec.homepage      = "https://github.com/domifyeu/email_error_handler"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/CHANGELOG.md"

  # Condition to use Git if available, otherwise use Dir.glob
  if File.exist?(".git") && system("git --version > /dev/null 2>&1")
    spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
      ls.readlines("\x0", chomp: true).reject do |f|
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
      end
    end
  else
    # Fall back to Dir.glob if Git is not available
    spec.files = Dir.glob("**/*").reject { |f| File.directory?(f) || f.end_with?('.gem') }
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 7.0"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "combustion"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "pry"
end
