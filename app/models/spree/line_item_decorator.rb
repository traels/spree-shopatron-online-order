Spree::LineItem.class_eval do
  def as_shopatron_item
  	# TODO make vat_inclusive configurable
  	# TODO make availability configurable / observe storage situation of item
    # TODO make Shopatron campaign stuff available on product/variant
  	{:product_id => variant.sku, :name => variant.name, :price => price.to_s.to_f, :actual_price => price.to_s.to_f, :avg_margin => 0.5, :vat_inclusive => 0, :quantity => quantity, :availability => 'Y'}
  end
end