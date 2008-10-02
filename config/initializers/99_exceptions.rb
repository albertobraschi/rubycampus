if defined? ExceptionNotifier
  ExceptionNotifier.exception_recipients = %w(exception@rubycampus.org)
  ExceptionNotifier.delivery_method = :smtp
end