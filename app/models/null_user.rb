require 'action_view'

class NullUser
  include ActionView::Helpers::AssetTagHelper

  def initialize(name)
    @name = name
  end

  def presenter
    self
  end

  def gravatar_image(options={})
    options = { size: 80 }.merge(options)
    image_tag("https://www.gravatar.com/avatar/1&d=retro&f=y", width: options[:size], id: options[:id],
              height: options[:size], alt: display_name, class: options[:class])
  end

  def display_name
    @name
  end

  def user_avatar_with_popover
    %Q(
      <a class="user-popover" 
        data-html="true" 
        data-container="body" 
        data-toggle="popover" 
        data-placement="right" 
        data-title="#{display_name}" 
        data-content="not registered" 
        href="#">
        #{gravatar_image(size: 40, id: 'user-gravatar', class: 'img-circle')}
      </a>
    ).html_safe
  end

end
