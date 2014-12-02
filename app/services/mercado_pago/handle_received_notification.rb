module MercadoPago
  class HandleReceivedNotification
    def initialize(notification)
      @notification = notification
    end

    # The purpose of this method is to enable async/sync processing
    # of Mercado Pago IPNs. For simplicity processing is synchronous but
    # if you would like to enqueue the processing via Resque/Ost/etc you
    # will be able to do it.
    def process!
      # Sync
      ProcessNotification.new(@notification).process!
      # Async Will be configurable via block for example:
      # Resque.enqueue(ProcessNotificationWorker, {id: @notification.id})
    end
  end
end
