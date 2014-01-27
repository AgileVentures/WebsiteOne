module DeviseHelper
  def devise_error_messages_flash
    return "" if resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| msg + '<br/>' }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)
    html = <<-HTML
  <div class="alert alert-danger">
    <b>#{sentence}</b>
    <p>#{messages}</p>
  </div>
    HTML
    html.html_safe
  end

  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <b>#{sentence}</b>
      <ul>#{messages}</ul>
    </div>
    HTML
    html.html_safe
  end


  def devise_error_simple_message
    return "" if resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| msg + '<br/>' }.join
    html = <<-HTML
      <div class="alert alert-danger">
        <p>#{messages}</p>
      </div>
    HTML
    html.html_safe
  end


end
