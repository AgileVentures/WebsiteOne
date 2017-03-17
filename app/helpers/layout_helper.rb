module LayoutHelper
  def flash_messages(opts={})
    @layout_flash = opts.fetch(:layout_flash) { true }

    capture do
      flash.each do |name, msg|
        concat content_tag(:div, msg, id: "flash_#{name}")
      end
    end
  end

  def show_layout_flash?
    @layout_flash.nil? ? true : @layout_flash
  end

  def event_name_or_invitation_to_guest_user(event)
    current_user ? event['name'] : "Want to learn more? Listen in. Next projects' review meeting "
  end
end

