module SpreeShopatronOnlineOrder
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_shopatron_online_order'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    initializer "spree_shopatron_online_order.environment", :before => :load_config_initializers, :after => "spree.environment" do |app|
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/models/app_configuration.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
      app.config.spree.add_class('shopatron')
      app.config.spree.shopatron = SpreeShopatronOnlineOrder::ShopatronConfig.new

      Spree::ShopatronConfig = app.config.spree.shopatron
    end

  end
end
