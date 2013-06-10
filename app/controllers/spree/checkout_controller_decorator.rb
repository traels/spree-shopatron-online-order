Spree::CheckoutController.class_eval do
  alias_method :orig_check_registration,  :check_registration unless method_defined? :orig_check_registration

  def check_registration
  	# rules for customers that are not logged in
  	unless spree_current_user or current_order.email
      unless Spree::ShopatronConfig.anonymous_can_skip_shopatron
        redirect_to spree.checkout_shopatron_path
        return
      end
    else
      # rules for users 
      force_shopatron = true
      roles = Spree::ShopatronConfig.roles_who_can_skip_shopatron.split(',').each do |role|
        role = role.strip
        force_shopatron = false if spree_current_user and spree_current_user.has_spree_role? role
      end  
     
      if force_shopatron
        redirect_to spree.checkout_shopatron_path
        return
      end
    end

  	# continue to original registration rules
    orig_check_registration
  end
end