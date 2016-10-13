require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'
require 'razorpay'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Luxire
  class Application < Rails::Application

    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end


    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.action_controller.perform_caching = true
    config.paperclip_defaults = {
      storage: :fog,
      :fog_credential => (File.join Rails.root, 'config', 'gce.yml') ,
      :fog_directory => "cloudhop-subscriber-luxire-cdn",
       }
    config.cache_store = :redis_store, { host: "luxire.redis.cache.windows.net",
                                     port: 6379,
                                     db: 0,
                                     password: "3XikIKiGcfuVJc17WBWOBwj3aXQv5uIkicjx3elIraA=",
                                     namespace: "cache",
                                     expires_in: 90.minutes }
    config.action_controller.default_url_options = {host: "test.store.luxire.com", port: "443", protocol: "https"}

  end
end
