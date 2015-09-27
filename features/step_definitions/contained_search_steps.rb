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

    when 'mercury toolbar', 'mercury editor toolbar'
      '.mercury-toolbar-container'

    when 'mercury modal', 'mercury editor modal'
      '.mercury-modal'

    else
      pending
  end
end

Then(/^(.*) within the (.*)$/) do |s, container|
  case container.downcase
    # Bryan: when xxx for more control

    when 'mercury editor'
      page.driver.within_frame('mercury_iframe') { step(s) }

    else
      page.within(css_selector_for(container.downcase)) { step (s) }
  end
end
