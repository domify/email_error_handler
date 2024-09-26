# frozen_string_literal: true

# Disable Ruby warnings globally
$VERBOSE = nil

# Ensure the gem's lib directory is in the load path before initializing
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

# Require the gem itself so that your engine is loaded
require "email_error_handler"

require 'bundler'
Bundler.require :default, :development

Combustion.path = "test/internal"
Combustion.initialize! :all

require "minitest/autorun"
