require 'spec_helper'

describe "Spree::Checkout" do
  before :each do
	Spree::ShopatronConfig.roles_who_can_skip_shopatron = "admin,notron"
  Spree::ShopatronConfig.anonymous_can_skip_shopatron = false
  Spree::ShopatronConfig.shopatron_catalog = "1386.0"
	@product = create(:product)
  end

  describe "anonymous users can be configured to skip shopatron" do
  	it "sends an anonymous user to shopatron" do
      Capybara.current_driver = :mechanize
   		Spree::ShopatronConfig.anonymous_can_skip_shopatron = false
      visit "/products/#{@product.to_param}"
      click_button('Add To Cart')
      visit spree.checkout_path
      page.should have_content("Shopatron")
      page.current_url.should =~ /tron.com/
      page.should_not have_content("IMPROPERLY")
  	end
  	it "sends an anonymous user to checkout registration" do
  		Spree::ShopatronConfig.anonymous_can_skip_shopatron = true
      visit "/products/#{@product.to_param}"
      click_button('Add To Cart')
      visit spree.checkout_path
      page.should have_content("Registration")
      current_path.should == "/checkout/registration"
  	end
  end

  describe "if user is in skip shopatron list" do
    it "should redirect to checkout" do
      sign_in_as!(create(:admin_user)) # admin is in list, so we should be allowed to checkout normally
      visit "/products/#{@product.to_param}"
      click_button('Add To Cart')
      visit spree.checkout_path
      page.should have_content("Checkout")
      current_path.should == "/checkout/address"
    end
  end

  describe "if user is not in skip shopatron list" do
    it "redirect to shopatron if order is good" do
      Capybara.current_driver = :mechanize
      visit "/products/#{@product.to_param}"
      click_button('Add To Cart')
      visit spree.checkout_path
      page.current_url.should =~ /tron.com/
      page.should_not have_content("IMPROPERLY")
     end

    it "redirects to cart with flash if order is not good" do
      Spree::ShopatronConfig.shopatron_catalog = "1386." # make sure shopatron fails
      sign_in_as!(create(:user))
      visit "/products/#{@product.to_param}"
      click_button('Add To Cart')
      visit spree.checkout_path
      page.should have_content("Shopatron failed")
      current_path.should == "/cart"
    end
  end



end
