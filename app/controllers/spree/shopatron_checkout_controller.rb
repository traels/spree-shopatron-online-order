class Spree::ShopatronCheckoutController < Spree::StoreController
  def index
    #require "xmlrpc/client"
    require 'xml/libxml/xmlrpc'
    require 'net/http'
 	  # create XML package with orderdata
  	items = {}
  	item_number = 0
  	current_order.line_items.each do |item|
  		item_number = item_number + 1
  		items["item_#{item_number}"] = item.as_shopatron_item
  	end

    number_of_items = 0
  	number_of_items = current_order.line_items.count if current_order

  	# send to Shopatron API
    #shopatron_rpc_server = XMLRPC::Client.new("xml.shopatron.com", "/xmlServer.php", 80)

    net = Net::HTTP.new("xml.shopatron.com", 80)
    shopatron_rpc_server = XML::XMLRPC::Client.new(net, "/xmlServer.php")

    begin
      # TODO make language_id and currency_id map to shopvalues with fallback where we hit outside Shopatron values
      cart_id = shopatron_rpc_server.call("examples.loadOrder", Spree::ShopatronConfig.shopatron_catalog,number_of_items,items,{:language_id=>1,:currency_id=>1})
      # if OK then empty order and redirect to shopatron web
  	  redirect_to "https://www.shopatron.com/xmlCheckout1.phtml?order_id=#{cart_id[0]}"
    rescue LibXML::XML::XMLRPC::RemoteCallError => e
#      puts "Error: #{e.faultCode}"
#      puts e.faultString
      # if order does not validate at Shopatron then redirect to cart with a flash
      flash[:error] = "Shopatron failed"
      redirect_to cart_path
    end

  end

  def ok
  end
end