unless Rails.env.test?
  Rack::Timeout.timeout = 20  # seconds
end
