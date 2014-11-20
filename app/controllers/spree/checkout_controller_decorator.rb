# # -*- encoding : utf-8 -*-
# Spree::CheckoutController.class_eval do
#   before_filter :redirect_to_mercado_pago_if_needed, :only => [:update]
# 
#   def redirect_to_mercado_pago_if_needed
#     return unless params[:state] == "payment"
# 
#     selected_method_id = params[:order][:payments_attributes].first[:payment_method_id]
#     @payment_method = Spree::PaymentMethod.find(selected_method_id)
# 
#     if @payment_method && @payment_method.kind_of?(PaymentMethod::MercadoPago)
#       @order.update_attributes(object_params)
# 
#       back_urls = {
#         success: spree.mercado_pago_success_url(order_number: @order.number),
#         pending: spree.mercado_pago_pending_url(order_number: @order.number),
#         failure: spree.mercado_pago_failure_url(order_number: @order.number)
#       }
# 
#       m = SpreeMercadoPagoClient.new(@order, back_urls)
#       
#       if m.authenticate && m.send_data
#         redirect_to m.redirect_url
#       else
#         render :action => :mercado_pago_error
#       end
#     end
#   end
# end
