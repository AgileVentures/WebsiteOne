# Bryan: already downcased
def css_selector_for(container)
  case container.downcase
    when 'navigation bar', 'navbar'
      '#nav'
    when 'sidebar'
      '#sidebar'
    when 'main content'
      '#main'
    when 'footer'
      '#footer'
    when 'list of projects'
      '#project-list'
    when 'modal dialog'
      '#modal-window'
    else
      "##{container}"
  end
end

Then(/^(.*) within the (.*)$/) do |s, container|
  page.within(css_selector_for(container.downcase)) { step (s) }
end