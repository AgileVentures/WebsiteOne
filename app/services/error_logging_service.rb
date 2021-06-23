# frozen_string_literal: true

class ErrorLoggingService
  def initialize(error)
    @error = error
  end

  def log(message)
    Rails.logger.warn message
    Rails.logger.error @error.message
    @error.backtrace.each { |line| Rails.logger.error line }
  end
end
