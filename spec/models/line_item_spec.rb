require 'spec_helper'

describe Spree::LineItem do
  it "has new as_shopatron_item method that returns values for shopatron" do
  	lineitem = create(:line_item)
  	lineitem.as_shopatron_item.class.name.should == "Hash"
  end

  describe "as_shopatron_item" do
  	it "returns Hash with line_item and variant data merged" do
  	  lineitem = create(:line_item)
  	  shopatron_item = lineitem.as_shopatron_item

  	  shopatron_item[:product_id].should == lineitem.variant.sku
  	  shopatron_item[:price].should == lineitem.price
  	  shopatron_item[:quantity].should == lineitem.quantity


  	end
  end
end