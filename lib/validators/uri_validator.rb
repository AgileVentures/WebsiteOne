require 'addressable/uri'
class UriValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    uri = parse_uri(value)
    if !uri
      record.errors[attribute] << generic_failure_message
    elsif !allowed_protocols.include?(uri.scheme)
      record.errors[attribute] << "must begin with #{allowed_protocols_humanized}"
    end
  end

  private

  def generic_failure_message
    options[:message] || "is an invalid URL"
  end

  def allowed_protocols_humanized
    allowed_protocols.to_sentence(:two_words_connector => ' or ')
  end

  def allowed_protocols
    @allowed_protocols ||= Array((options[:allowed_protocols] || ['http', 'https']))
  end

  def parse_uri(value)
    uri = Addressable::URI.parse(value)
    uri.scheme && uri.host && uri
  rescue URI::InvalidURIError, Addressable::URI::InvalidURIError, TypeError
  end

end
