Spree::Core::Engine.routes.draw do
  get 'checkout/shopatron' => "shopatron_checkout#index", :as => :checkout_shopatron
end
