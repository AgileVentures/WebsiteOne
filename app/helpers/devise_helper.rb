# frozen_string_literal: true

module DeviseHelper
  def devise_error_simple_message
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| "#{msg}<br/>" }.join
    html = yield(messages) if block_given?
    html ||= <<-HTML
        <div class="alert alert-danger">
        <p>#{messages}</p>
        </div>
    HTML
    html.html_safe
  end

  def devise_error_messages_flash
    devise_error_simple_message do |messages|
      sentence = I18n.t('errors.messages.not_saved',
                        count: resource.errors.count,
                        resource: resource.class.model_name.human.downcase)
      <<-HTML
        <div class="alert alert-danger">
        <strong>#{sentence}</strong>
        <p>#{messages}</p>
        </div>
      HTML
    end
  end
end
