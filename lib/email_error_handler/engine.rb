module EmailErrorHandler
  class Engine < ::Rails::Engine
    initializer 'email_error_handler.add_locales' do |app|
      # Add the locale files to I18n load path and ensure uniqueness
      I18n.load_path += Dir[File.join(root, 'config', 'locales', '*.yml')].uniq
    end

    initializer :append_migrations do |app|
      # Add migrations from the engine unless the engine is already part of the app
      unless app.root.to_s.match?(root.to_s)
        config.paths['db/migrate'].expanded.each do |expanded_path|
          unless app.config.paths['db/migrate'].include?(expanded_path)
            app.config.paths['db/migrate'] << expanded_path
          end
        end
      end
    end

    # Load the generators only in development or test environments to avoid unnecessary generator loading in production.
    config.generators do |g|
      g.test_framework :minitest, spec: true
    end

    # Register the generator
    initializer 'email_error_handler.load_generators' do
      if Rails.env.development? || Rails.env.test?
        require_relative 'generators/migration/migration_generator'
      end
    end
  end
end
