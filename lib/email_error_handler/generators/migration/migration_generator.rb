# lib/generators/email_error_handler/migration/migration_generator.rb
require 'rails/generators'
require 'rails/generators/active_record'

module EmailErrorHandler
  module Generators
    class MigrationGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('templates', __dir__)

      # Argument for model name
      argument :model_name, type: :string, required: true, banner: "ModelName"

      def create_migration_file
        # Define the migration name dynamically based on the model
        migration_template "migration.rb.erb", "db/migrate/add_email_error_handler_to_#{model_name.underscore}.rb"
      end

      private

      # Define the table name based on the model name
      def table_name
        model_name.underscore.pluralize
      end
    end
  end
end
