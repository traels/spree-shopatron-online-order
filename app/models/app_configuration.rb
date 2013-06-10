module SpreeShopatronOnlineOrder
  class ShopatronConfig < Spree::Preferences::Configuration
    preference :roles_who_can_skip_shopatron, :string, :default => ""
    preference :anonymous_can_skip_shopatron, :boolean, :default => false
    preference :shopatron_catalog, :string, :default => ""
  end
end